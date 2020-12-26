//
//  TabDownloadViewController.swift
//  TikMate
//
//  Created by ChuoiChien on 12/15/20.
//

import UIKit
import Photos
import FCFileManager
import GoogleMobileAds

class TabDownloadViewController: BaseViewController {
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var heightContraintBannerView: NSLayoutConstraint!
    
    @IBOutlet weak var imgRightBar: UIImageView!
    @IBOutlet weak var lbCoin: UILabel!
    @IBOutlet weak var lbIntroDownload: UILabel!
    @IBOutlet weak var lbAutoDownload: UILabel!
    @IBOutlet weak var inputLinkView: UIView!
    @IBOutlet weak var txtInput: UITextField!
    
    @IBOutlet weak var bottomContanstViewAds: NSLayoutConstraint!
    @IBOutlet weak var viewCenterCenterYContraint: NSLayoutConstraint!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if IS_IPHONE_5_5S_SE {
            bottomContanstViewAds.constant = 80
            viewCenterCenterYContraint.constant = 55
        } else if IS_IPHONE_6_6S_7_8 {
            bottomContanstViewAds.constant = 120
        } else if IS_IPHONE_6PLUS_7PLUS_8PLUS {
            bottomContanstViewAds.constant = 130
        } else if IS_IPHONE_X_XS {
            
        } else if IS_IPHONE_XR_XSMAX_11 {
            
        } else {
            
        }
        indicator.isHidden = true
        updateUI()
        DatabaseFireBaseManager.shared.fetchData {
            // update UI
            self.updateUI()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(createVideoSuccess(_:)), name: NSNotification.Name(rawValue: NotificationCenterName.createVideoSuccess), object: nil)
        
        checkPhotoLibraryPermission()
        UserModel.share.last_online = Common.getStringFromDate()
        DatabaseFireBaseManager.shared.postChangeUserLastOnline()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.inputLinkView.gradientBorder(width: 1, colors: [UIColor.green, UIColor.red], startPoint: CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint(x: 1.0, y: 1.0), andRoundCornersWithRadius: 22)
        
        if UserModel.share.isVip == false {
            let isNeverShowPopup = UserDefaults.standard.bool(forKey: KEY_IS_NERVER_SHOW_POPUP)
            if isNeverShowPopup == false && IS_DONATE_COIN_NEWDAY.IS_DONATE == true  && IS_DONATE_COIN_NEWDAY.IS_SHOW == true {
                appDelegate?.rootViewController.presentModalyWithoutAnimate(PopupDonateViewController.newInstance())
            }
        }
    }
    
    @IBAction func clickMenu(_ sender: Any) {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
    @IBAction func switchAutoDownload(_ sender: Any) {
        
    }
    
    @IBAction func clickDownload(_ sender: Any) {
        guard txtInput.text != "" else {
            Common.showAlert(type: kAlertType.warning, title: "", content: "Please paste url link !", completeActionTitle: "OK", cancelActionTitle: "", showCancelAction: false, completion: nil, close: nil)
            return
        }
        if (UserModel.share.isVip == false) && Int(UserModel.share.coin)! < CoinConfig.downloadSuccess {
            appDelegate?.rootViewController.presentModalyWithoutAnimate(PopupWarningViewController.newInstance())
            return
        }
        var params = [String: Any]()
        params["urlString"] = txtInput.text
        txtInput.text = ""
        
        if UserModel.share.isVip == true {
            getLinkDownloadVip(params: params)
        } else {
            getLinkDownload(params: params)
        }
    }
    
    @IBAction func clickPasteLink(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        txtInput.text = pasteboard.string
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

extension TabDownloadViewController {
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            break
        //handle authorized status
        case .denied, .restricted :
            break
        //handle denied status
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    break
                // as above
                case .denied, .restricted:
                    // as above
                    break
                case .notDetermined:
                    // won't happen but still
                    break
                default:
                    break
                    
                }
            }
        default:
            break
        }
    }
}

extension TabDownloadViewController: GADBannerViewDelegate {
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

extension TabDownloadViewController {
    func getLinkDownload(params: [String: Any]) -> Void {
        LoadingManager.show(in: self)
        ApiSevice.getLinkVideo(params) { (response, error) in
            LoadingManager.hide()
            if response?.statusCode == 0 {
                let video = VideoModel()
                video.detailURL = response?.info["detail"] as! String
                let item = response?.items.first
                video.ID = item!["id"] as! String
                video.desc = item!["desc"] as! String
                
                let dicVideo = item!["video"] as! [String: Any]
                video.coverImage = dicVideo["cover"] as! String
                video.downloadURL = dicVideo["playAddr"] as! String
                
                self.downloadVideo(video: video)
            } else {
                Common.showAlert(content: "Download error!")
            }
        }
    }
    func downloadVideo(video: VideoModel) -> Void {
        LoadingManager.showDownloading(in: self)
        ApiSevice.downloadFile(fileURL: URL(string: video.downloadURL)!, fileName: video.ID) { (filePath, isSuccess) in
            if isSuccess == false {return}
            
            let localPath = FolderPath.video + "/" + video.ID + ".mp4"
            video.pathURL = localPath
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: FCFileManager.urlForItem(atPath: video.pathURL))
            }) { saved, error in
                if saved {
                    DispatchQueue.main.async {
                        DatabaseRealmManager.shared.create(video: video)
                    }
                } else {
                    DispatchQueue.main.async {
                        Common.showAlert(content: "Can not save video to camera roll !")
                    }
                }
            }
        }
    }
    
    func getLinkDownloadVip(params: [String: Any]) -> Void {
        indicator.isHidden = false
        indicator.startAnimating()
        ApiSevice.getLinkVideo(params) { (response, error) in
            if response?.statusCode == 0 {
                let video = VideoModel()
                video.detailURL = response?.info["detail"] as! String
                let item = response?.items.first
                video.ID = item!["id"] as! String
                video.desc = item!["desc"] as! String
                
                let dicVideo = item!["video"] as! [String: Any]
                video.coverImage = dicVideo["cover"] as! String
                video.downloadURL = dicVideo["playAddr"] as! String
                
                self.downloadVideoVip(video: video)
            } else {
                Common.showAlert(content: "Download error!")
            }
        }
    }
    func downloadVideoVip(video: VideoModel) -> Void {
        ApiSevice.downloadFile(fileURL: URL(string: video.downloadURL)!, fileName: video.ID) { (filePath, isSuccess) in
            if isSuccess == false {return}
            
            let localPath = FolderPath.video + "/" + video.ID + ".mp4"
            video.pathURL = localPath
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: FCFileManager.urlForItem(atPath: video.pathURL))
            }) { saved, error in
                if saved {
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
                    DispatchQueue.main.async {
                        DatabaseRealmManager.shared.create(video: video)
                    }
                } else {
                    DispatchQueue.main.async {
                        Common.showAlert(content: "Can not save video to camera roll !")
                    }
                }
            }
        }
    }
}

extension TabDownloadViewController {
    @objc func createVideoSuccess(_ notification: Notification) {
        // Download video and save to camera roll success => decrease coin
        let newCoin = Int(UserModel.share.coin)! - CoinConfig.downloadSuccess
        UserModel.share.coin = String(newCoin)
        DatabaseFireBaseManager.shared.postChangeUserCoin()
    }
}
