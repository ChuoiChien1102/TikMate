//
//  BuyVipViewController.swift
//  TikMate
//
//  Created by ChuoiChien on 12/24/20.
//

import UIKit

class BuyVipViewController: UIViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnRestore: UIButton!
    @IBOutlet weak var lbGoPremium: UILabel!
    @IBOutlet weak var lbIntro1: UILabel!
    @IBOutlet weak var lbIntro2: UILabel!
    @IBOutlet weak var lbIntro3: UILabel!
    
    @IBOutlet weak var lbVip1Week: UILabel!
    @IBOutlet weak var lbIntroVip1Week: UILabel!
    @IBOutlet weak var lbVip1Month: UILabel!
    @IBOutlet weak var lbIntroVip1Month: UILabel!
    @IBOutlet weak var lbVip3Month: UILabel!
    @IBOutlet weak var lbIntroVip3Month: UILabel!
    
    @IBOutlet weak var btnVip1Week: UIButton!
    @IBOutlet weak var btnVip1Month: UIButton!
    @IBOutlet weak var btnVip3Month: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lbTitle.text = R.string.localizable.buyVIP()
        lbGoPremium.text = R.string.localizable.gopremiuM()
        lbIntro1.text = R.string.localizable.downloadUnlimitedVideosWithoutAnyWatermarks()
        lbIntro2.text = R.string.localizable.adsFree()
        lbIntro3.text = R.string.localizable.saveYourTimeByMultipleDownloads()
        lbVip1Week.text = R.string.localizable.vip1Week()
        lbIntroVip1Week.text = R.string.localizable.freeTrial3Days()
        lbVip1Month.text = R.string.localizable.vip1Month()
        lbIntroVip1Month.text = R.string.localizable.freeTrial5Days()
        lbVip3Month.text = R.string.localizable.vip3Month()
        lbIntroVip3Month.text = R.string.localizable.freeTrial1Days()
        
        getProductInfo()
    }
    
    @IBAction func clickClose(_ sender: Any) {
        appDelegate?.rootViewController.dismissModalyWithoutAnimate(self, completion: nil)
    }

    @IBAction func restore(_ sender: Any) {
        LoadingManager.show(in: self)
        PurchaserManager.restorePurchase {
            LoadingManager.hide()
            self.dismiss(animated: true, completion: nil)
        } failurehandler: { (str) in
            LoadingManager.hide()
            Common.showAlert(content: str)
        }
    }
    
    @IBAction func clickVip1Week(_ sender: Any) {
        let productToPurchase = KeysIAP.ONE_WEEK.appId
        LoadingManager.show(in: self)
        PurchaserManager.purchaseAProduct(productID: productToPurchase) {
            LoadingManager.hide()
            UserModel.share.isVip = true
            DatabaseFireBaseManager.shared.postChangeUserIsVip()
        } failureHandler: { (str) in
            LoadingManager.hide()
            Common.showAlert(content: str)
        }
    }
    
    @IBAction func clickVip1Month(_ sender: Any) {
        let productToPurchase = KeysIAP.ONE_MONTH.appId
        LoadingManager.show(in: self)
        PurchaserManager.purchaseAProduct(productID: productToPurchase) {
            LoadingManager.hide()
            UserModel.share.isVip = true
            DatabaseFireBaseManager.shared.postChangeUserIsVip()
        } failureHandler: { (str) in
            LoadingManager.hide()
            Common.showAlert(content: str)
        }
    }
    
    @IBAction func clickVip3Month(_ sender: Any) {
        let productToPurchase = KeysIAP.THREE_MONTHS.appId
        LoadingManager.show(in: self)
        PurchaserManager.purchaseAProduct(productID: productToPurchase) {
            LoadingManager.hide()
            UserModel.share.isVip = true
            DatabaseFireBaseManager.shared.postChangeUserIsVip()
        } failureHandler: { (str) in
            LoadingManager.hide()
            Common.showAlert(content: str)
        }
    }
}

extension BuyVipViewController {
    func getProductInfo() -> Void {
        LoadingManager.show(in: self)
        PurchaserManager.getInfo(ProductIds: [KeysIAP.ONE_WEEK.appId, KeysIAP.ONE_MONTH.appId, KeysIAP.THREE_MONTHS.appId]) { (skProducts) in
            LoadingManager.hide()
            for i in skProducts {
                guard let price = i.localizedPrice else { return }
                print(price)
                if i.productIdentifier == KeysIAP.ONE_WEEK.appId {
                    self.btnVip1Week.setTitle(price, for: .normal)
                }
                if i.productIdentifier == KeysIAP.ONE_MONTH.appId {
                    self.btnVip1Month.setTitle(price, for: .normal)
                }
                if i.productIdentifier == KeysIAP.THREE_MONTHS.appId {
                    self.btnVip3Month.setTitle(price, for: .normal)
                }
            }
        }
    }
}
