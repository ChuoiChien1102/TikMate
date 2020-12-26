//
//  TabCoinViewController.swift
//  TikMate
//
//  Created by ChuoiChien on 12/15/20.
//

import UIKit
import GoogleMobileAds

class CoinMenu: NSObject {
    var iconName = ""
    var name = ""
    var detail = ""
}

class TabCoinViewController: BaseViewController {
    @IBOutlet weak var imgRightBar: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbCoin: UILabel!
    
    var arrayMenu = [CoinMenu]()
    var rewardedAd: GADRewardedAd?
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        updateUI()
        DatabaseFireBaseManager.shared.fetchData {
            // update UI
            self.updateUI()
        }
        
        tableView.registerCellNib(CoinMenuTableViewCell.self)
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        let watch = CoinMenu()
        watch.name = "Watch videos (Ads)"
        watch.iconName = "ic_info"
        watch.detail = "Watch funny videos and earn coins"
        arrayMenu.append(watch)
        
        let buyCoin = CoinMenu()
        buyCoin.name = "Buy coins"
        buyCoin.iconName = "ic_buy_coin"
        buyCoin.detail = "Get coin immediately"
        arrayMenu.append(buyCoin)
        
        let buyVip = CoinMenu()
        buyVip.name = "Buy VIP"
        buyVip.iconName = "ic_use"
        buyVip.detail = "Ads-free and download unlimited videos"
        arrayMenu.append(buyVip)
        
        // add ads
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func clickMenu(_ sender: Any) {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
    func updateUI() -> Void {
        if UserModel.share.isVip == true {
            imgRightBar.image = UIImage(named: "ic_vip")
            lbCoin.isHidden = true
        } else {
            imgRightBar.image = UIImage(named: "ic_coin")
            lbCoin.text = String(UserModel.share.coin)
        }
    }
}

extension TabCoinViewController {
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: App.INTERSTITIAL_ADS_ID_TEST)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
}

extension TabCoinViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.className(CoinMenuTableViewCell.self)) as! CoinMenuTableViewCell
        
        let item = arrayMenu[indexPath.row]
        cell.configUI(menu: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 83
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if self.rewardedAd?.isReady == true {
                self.rewardedAd?.present(fromRootViewController: self, delegate:self)
            } else {
                // show ads insterstitial
                if interstitial.isReady {
                    interstitial.present(fromRootViewController: self)
                } else {
                    Common.showAlert(content: "Ads wasn't ready")
                }
            }
            break
        case 1:
            appDelegate?.rootViewController.presentModalyWithoutAnimate(BuyCoinViewController.newInstance())
            break
        case 2:
            appDelegate?.rootViewController.presentModalyWithoutAnimate(BuyVipViewController.newInstance())
            break
        default:
            break
        }
    }
}

extension TabCoinViewController: GADRewardedAdDelegate {
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        let newCoin = Int(UserModel.share.coin)! + Int(FIRRemoteConfig.shared.ios_tikmate_watch_video_reward)!
        UserModel.share.coin = String(newCoin)
        DatabaseFireBaseManager.shared.postChangeUserCoin()
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

extension TabCoinViewController: GADInterstitialDelegate  {
    
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
    }
    
    // Tells the delegate that a user click will open another app
    // (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
}
