//
//  BuyCoinViewController.swift
//  TikMate
//
//  Created by ChuoiChien on 12/24/20.
//

import UIKit

class BuyCoinViewController: UIViewController {
    @IBOutlet weak var btnTiny: UIButton!
    @IBOutlet weak var btnSmall: UIButton!
    @IBOutlet weak var btnMedium: UIButton!
    @IBOutlet weak var btnLarge: UIButton!
    @IBOutlet weak var btnHuge: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getProductInfo()
    }
    
    @IBAction func clickClose(_ sender: Any) {
        appDelegate?.rootViewController.dismissModalyWithoutAnimate(self, completion: nil)
    }
    
    @IBAction func clickTiny(_ sender: Any) {
        let productToPurchase = KeysIAP.ios_tikmate_consumable_tinypack.appId
        LoadingManager.show(in: self)
        PurchaserManager.purchaseAProduct(productID: productToPurchase) {
            LoadingManager.hide()
            let newCoin = Int(UserModel.share.coin)! + Int(FIRRemoteConfig.shared.ios_tikmate_consumable_tinypack)!
            UserModel.share.coin = String(newCoin)
            DatabaseFireBaseManager.shared.postChangeUserCoin()
        } failureHandler: { (str) in
            LoadingManager.hide()
            Common.showAlert(content: str)
        }
    }
    
    @IBAction func clickSmall(_ sender: Any) {
        let productToPurchase = KeysIAP.ios_tikmate_consumable_smallpack.appId
        LoadingManager.show(in: self)
        PurchaserManager.purchaseAProduct(productID: productToPurchase) {
            LoadingManager.hide()
            let newCoin = Int(UserModel.share.coin)! + Int(FIRRemoteConfig.shared.ios_tikmate_consumable_smallpack)!
            UserModel.share.coin = String(newCoin)
            DatabaseFireBaseManager.shared.postChangeUserCoin()
        } failureHandler: { (str) in
            LoadingManager.hide()
            Common.showAlert(content: str)
        }
    }
    
    @IBAction func clickMedium(_ sender: Any) {
        let productToPurchase = KeysIAP.ios_tikmate_consumable_mediumpack.appId
        LoadingManager.show(in: self)
        PurchaserManager.purchaseAProduct(productID: productToPurchase) {
            LoadingManager.hide()
            let newCoin = Int(UserModel.share.coin)! + Int(FIRRemoteConfig.shared.ios_tikmate_consumable_mediumpack)!
            UserModel.share.coin = String(newCoin)
            DatabaseFireBaseManager.shared.postChangeUserCoin()
        } failureHandler: { (str) in
            LoadingManager.hide()
            Common.showAlert(content: str)
        }
    }
    
    @IBAction func clickLarge(_ sender: Any) {
        let productToPurchase = KeysIAP.ios_tikmate_consumable_largepack.appId
        LoadingManager.show(in: self)
        PurchaserManager.purchaseAProduct(productID: productToPurchase) {
            LoadingManager.hide()
            let newCoin = Int(UserModel.share.coin)! + Int(FIRRemoteConfig.shared.ios_tikmate_consumable_largepack)!
            UserModel.share.coin = String(newCoin)
            DatabaseFireBaseManager.shared.postChangeUserCoin()
        } failureHandler: { (str) in
            LoadingManager.hide()
            Common.showAlert(content: str)
        }
    }
    
    @IBAction func clickHuge(_ sender: Any) {
        let productToPurchase = KeysIAP.ios_tikmate_consumable_hugepack.appId
        LoadingManager.show(in: self)
        PurchaserManager.purchaseAProduct(productID: productToPurchase) {
            LoadingManager.hide()
            let newCoin = Int(UserModel.share.coin)! + Int(FIRRemoteConfig.shared.ios_tikmate_consumable_hugepack)!
            UserModel.share.coin = String(newCoin)
            DatabaseFireBaseManager.shared.postChangeUserCoin()
        } failureHandler: { (str) in
            LoadingManager.hide()
            Common.showAlert(content: str)
        }
    }
    
}

extension BuyCoinViewController {
    func getProductInfo() -> Void {
        LoadingManager.show(in: self)
        PurchaserManager.getInfo(ProductIds: [KeysIAP.ios_tikmate_consumable_tinypack.appId, KeysIAP.ios_tikmate_consumable_smallpack.appId, KeysIAP.ios_tikmate_consumable_mediumpack.appId,KeysIAP.ios_tikmate_consumable_largepack.appId,KeysIAP.ios_tikmate_consumable_hugepack.appId]) { (skProducts) in
            LoadingManager.hide()
            for i in skProducts {
                guard let price = i.localizedPrice else { return }
                print(price)
                if i.productIdentifier == KeysIAP.ios_tikmate_consumable_tinypack.appId {
                    self.btnTiny.setTitle(price, for: .normal)
                }
                if i.productIdentifier == KeysIAP.ios_tikmate_consumable_smallpack.appId {
                    self.btnSmall.setTitle(price, for: .normal)
                }
                if i.productIdentifier == KeysIAP.ios_tikmate_consumable_mediumpack.appId {
                    self.btnMedium.setTitle(price, for: .normal)
                }
                if i.productIdentifier == KeysIAP.ios_tikmate_consumable_largepack.appId {
                    self.btnLarge.setTitle(price, for: .normal)
                }
                if i.productIdentifier == KeysIAP.ios_tikmate_consumable_hugepack.appId {
                    self.btnHuge.setTitle(price, for: .normal)
                }
            }
        }
    }
}
