//
//  PopupWarningViewController.swift
//  TikMate
//
//  Created by ChuoiChien on 12/22/20.
//

import UIKit
import GoogleMobileAds

class PopupWarningViewController: BaseViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbOr: UILabel!
    @IBOutlet weak var btnWatchAds: UIButton!
    @IBOutlet weak var btnBuyCoin: UIButton!
    @IBOutlet weak var btnOk: UIButton!

    var rewardedAd: GADRewardedAd?
    var interstitial: GADInterstitial!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lbTitle.text = R.string.localizable.warning()
        lbContent.text = R.string.localizable.youDoNotHaveEnoughCoinsToDownloadPlease()
        btnWatchAds.setTitle(R.string.localizable.watchTheVideoAdvertisement(), for: .normal)
        lbOr.text = R.string.localizable.or()
        btnBuyCoin.setTitle(R.string.localizable.buyMoreCoin(), for: .normal)
        btnOk.setTitle(R.string.localizable.oK(), for: .normal)
        
        rewardedAd = GADRewardedAd(adUnitID: App.REWARD_ADS_ID_TEST)
        rewardedAd?.load(GADRequest()) { error in
            if let error = error {
                // show ads insterstitial
                print(error.description)
            } else {
                // Ad successfully loaded.
            }
        }
        interstitial = createAndLoadInterstitial()
    }
    
    @IBAction func clickWatchAds(_ sender: Any) {
        if self.rewardedAd?.isReady == true {
            self.rewardedAd?.present(fromRootViewController: self, delegate:self)
        } else {
            // show ads insterstitial
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            } else {
                Common.showAlert(content: R.string.localizable.adsWasnTReady())
            }
        }
    }
    
    @IBAction func clickBuyCoin(_ sender: Any) {
        appDelegate?.rootViewController.dismissModalyWithoutAnimate(self, completion: {
            self.appDelegate?.rootViewController.presentModalyWithoutAnimate(BuyCoinViewController.newInstance())
        })
    }
    
    @IBAction func clickOK(_ sender: Any) {
        appDelegate?.rootViewController.dismissModalyWithoutAnimate(self, completion: nil)
    }
}

extension PopupWarningViewController {
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: App.INTERSTITIAL_ADS_ID_TEST)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
}

extension PopupWarningViewController: GADRewardedAdDelegate {
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        let newCoin = Int(UserModel.share.coin)! + Int(FIRRemoteConfig.shared.ios_tikmate_watch_video_reward)!
        UserModel.share.coin = String(newCoin)
        DatabaseFireBaseManager.shared.postChangeUserCoin()
        appDelegate?.rootViewController.dismissModalyWithoutAnimate(self, completion: nil)
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print("Rewarded ad failed to present.")
        // show Ads insterstitial
    }
    
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad presented.")
    }
    
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad dismissed.")
    }
    
}

extension PopupWarningViewController: GADInterstitialDelegate  {
    
    // Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    // Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    // Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    // Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        let newCoin = Int(UserModel.share.coin)! + Int(FIRRemoteConfig.shared.ios_tikmate_watch_interstitial)!
        UserModel.share.coin = String(newCoin)
        DatabaseFireBaseManager.shared.postChangeUserCoin()
        appDelegate?.rootViewController.dismissModalyWithoutAnimate(self, completion: nil)
    }
    
    // Tells the delegate that a user click will open another app
    // (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
}
