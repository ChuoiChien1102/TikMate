//
//  PurchaserManager.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 12/7/20.
//

import Foundation
import SwiftyStoreKit
import StoreKit

final class PurchaserManager : NSObject {
    
    //ProductsIds
    static let ONE_WEEK: String = KeysIAP.ONE_WEEK.appId
    static let ONE_MONTH: String = KeysIAP.ONE_MONTH.appId
    static let THREE_MONTHS: String = KeysIAP.THREE_MONTHS.appId
    
    static let appSharedSecret: String = KeysIAP.appSpecificSharedSecret.appId
    static let services: AppleReceiptValidator.VerifyReceiptURLType = .production
    
    
    //MARK:- Verifying purchases and subscriptions
    
    /**
     - Dùng để verify lại gói SUBSCRIPTION của người dùng ( gói tuần, tháng , năm )
     - Được gọi mỗi lần mở app, hoặc restore
     - Verify the purchase of a Subscription
     
     - Parameters:
     - arrs: Mảng productID ( subscription ) cần verify
     - successHandler: Closure -> Khi người dùng trả phí thành công
     - failureHandler: Closure -> Khi người dùng trả phí thất bại, và gửi kèm lỗi
     
     - Returns: Void()
     */
    
    class func verifySubscriptions( ProductIds arrs:[String],
                                    successHandler:@escaping () -> Void,
                                    failureHandler: @escaping (String) -> Void
    ) {
        
        let appleValidator = AppleReceiptValidator(service: services,
                                                   sharedSecret: appSharedSecret)
        
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productIds = Set(arrs)
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productIds) are valid until \(expiryDate)\n\(items)\n")
                    successHandler()
                case .expired(let expiryDate, _):
                    //          expiredHandler("\(productIds) are expired since \(expiryDate)")
                    failureHandler("Products are expired since \(expiryDate), please purchase again!")
                case .notPurchased:
                    print("The user has never purchased \(productIds)")
                    failureHandler("The user has never purchased \(productIds)")
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
                failureHandler("Receipt verification failed: \(error)")
            }
        }
    }
    
    //MARK:- Restore purchase
    
    /**
     -  Restore lại gói purchase đã mua
     -   Kiểm tra gói subscription
     
     - Parameters:
     - successHandler: Restore thành công
     - failurehandler:  Restore thất bại, gửi kèm mã lỗi
     
     - Returns: Void()
     */
    
    class func restorePurchase(
        successHandler :@escaping () -> Void,
        failurehandler  :@escaping (String) -> Void) {
        
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                failurehandler("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                //Verify gói sub
                self.verifySubscriptions(ProductIds: [ONE_WEEK,ONE_MONTH,THREE_MONTHS]) {
                    //Success
                    UserModel.share.isVip = true
                    DatabaseFireBaseManager.shared.postChangeUserIsVip()
                    successHandler()
                } failureHandler: { (str) in
                    //Failure
                    UserModel.share.isVip = false
                    DatabaseFireBaseManager.shared.postChangeUserIsVip()
                    failurehandler(str)
                }
            }
            else {
                failurehandler("Nothing to Restore")
            }
        }
    }
    
    
    //MARK:- Purchase a product (given a product id)
    
    
    /**
     -   Khi trả phí 1 sản phẩm
     
     - Parameters:
     - productIds: ProdocutID cần thanh toán ví dụ: com.artermis.awesome.weekly
     - completionHandler:  Khi trả phí thành công
     - failureHandler:  Khi trả phí thất bại, sẽ gửi kèm string lỗi để thông báo cho người dùng
     
     - Returns: Void()
     */
    
    class func purchaseAProduct(productID:String,
                                completionHandler: @escaping () -> Void,
                                failureHandler: @escaping (String) -> Void) {
        SwiftyStoreKit.purchaseProduct(productID, quantity: 1, atomically: true) { result in
            switch result {
            case .success:
                completionHandler()
            //Logic when purchase success
            
            case .error(let error):
                switch error.code {
                case .unknown:
                    failureHandler("Purchase fail, please try again!")
                case .clientInvalid:
                    failureHandler("Not allowed to make the payment")
                case .paymentCancelled:
                    failureHandler("PaymentCancelled")
                case .paymentInvalid:
                    failureHandler("The purchase identifier was invalid")
                case .paymentNotAllowed:
                    failureHandler("The device is not allowed to make the payment")
                case .storeProductNotAvailable:
                    failureHandler("The product is not available in the current storefront")
                case .cloudServicePermissionDenied:
                    failureHandler("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed:
                    failureHandler("Could not connect to the network")
                case .cloudServiceRevoked:
                    failureHandler("User has revoked permission to use this cloud service")
                default:
                    failureHandler((error as NSError).localizedDescription)
                }
            }
        }
    }
    
    
    /**
     Gọi cái này mỗi lần mở app
     
     - Parameters:
     - completionHandler: Khi hoàn thành verify
     
     - Returns: Void()
     */
    
    class func completeTransactions(completionHandler: @escaping () -> Void) {
        // see notes below for the meaning of Atomic / Non-Atomic
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
        }
        print("===================Call Complete Transactions ===================")
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        //Verify gói sub
        self.verifySubscriptions(ProductIds: [ONE_WEEK,ONE_MONTH,THREE_MONTHS]) {
            //Success
            UserModel.share.isVip = true
            DatabaseFireBaseManager.shared.postChangeUserIsVip()
            dispatchGroup.leave()
        } failureHandler: { (str) in
            //Failure
            UserModel.share.isVip = false
            DatabaseFireBaseManager.shared.postChangeUserIsVip()
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print("Multil functions complete 👍")
            completionHandler()
        }
    }
    
    class func getInfo( ProductIds proIds:[String],
                        completed:@escaping (_ products: Set<SKProduct>) -> Void){
        SwiftyStoreKit.retrieveProductsInfo(Set(proIds))
        { result in
            if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            if let error = result.error {
                print("error = \(error.localizedDescription)")
            }
            completed(result.retrievedProducts)
        }
    }
}


enum PurchaseStatus {
    case success
    case error( msg: String)
}
