//
//  TabVideoTutorialViewController.swift
//  TikMate
//
//  Created by ChuoiChien on 12/17/20.
//

import UIKit
import GoogleMobileAds

class TabVideoTutorialViewController: BaseViewController {
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var heightContraintBannerView: NSLayoutConstraint!
    @IBOutlet weak var imgRightBar: UIImageView!
    @IBOutlet weak var lbCoin: UILabel!
    @IBOutlet weak var lbIntro: UILabel!
    
    @IBOutlet weak var heightContraintView1: NSLayoutConstraint!
    @IBOutlet weak var heightContraintView2: NSLayoutConstraint!
    @IBOutlet weak var heightContraintView3: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if IS_IPHONE_5_5S_SE {
            
        } else if IS_IPHONE_6_6S_7_8 {
            
        } else if IS_IPHONE_6PLUS_7PLUS_8PLUS {
            heightContraintView2.constant = 650
            heightContraintView3.constant = 650
        } else if IS_IPHONE_X_XS {
            
        } else if IS_IPHONE_XR_XSMAX_11 {
            heightContraintView2.constant = 650
            heightContraintView3.constant = 650
        } else {
            
        }
        
        lbIntro.text = R.string.localizable.yourDownloadVideosWillAppearHerePleaseSeeBellowIntructionToDownloadVideosWithoutAnyWatermask()
        
        updateUI()
        DatabaseFireBaseManager.shared.fetchData {
            // update UI
            self.updateUI()
        }
    }
    
    @IBAction func clickMenu(_ sender: Any) {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }

    func updateUI() -> Void {
        // config Banner Ads
        if UserModel.share.isVip == true {
            bannerView.isHidden = true
            heightContraintBannerView.constant = 0
            imgRightBar.image = UIImage(named: "ic_vip")
            lbCoin.isHidden = true
        } else {
            imgRightBar.image = UIImage(named: "ic_coin")
            lbCoin.text = String(UserModel.share.coin)
            bannerView.adUnitID = App.BANNER_ADS_ID_TEST
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            bannerView.delegate = self
        }
    }
}

extension TabVideoTutorialViewController: GADBannerViewDelegate {
    // Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("adViewDidReceiveAd")
    }

    // Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    // Tells the delegate that a full-screen view will be presented in response
    // to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    // Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    // Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    // Tells the delegate that a user click will open another app (such as
    // the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }
}

