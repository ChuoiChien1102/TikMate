//
//  TabVideoViewController.swift
//  TikMate
//
//  Created by ChuoiChien on 12/15/20.
//

import UIKit
import AVKit
import FCFileManager
import SDCAlertView
import Photos
import GoogleMobileAds

class TabVideoViewController: BaseViewController {
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var heightContraintBannerView: NSLayoutConstraint!
    @IBOutlet weak var imgRightBar: UIImageView!
    @IBOutlet weak var lbCoin: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var listVideo = [VideoModel]()
    
    private let itemsPerRow: CGFloat = 2
    fileprivate let sectionInset = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 0.0, right: 15.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(createVideoSuccess(_:)), name: NSNotification.Name(rawValue: NotificationCenterName.createVideoSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteVideoSuccess(_:)), name: NSNotification.Name(rawValue: NotificationCenterName.deleteVideoSuccess), object: nil)
        
        updateUI()
        DatabaseFireBaseManager.shared.fetchData {
            // update UI
            self.updateUI()
        }
        
        collectionView.register(UINib(nibName: "VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoCollectionViewCell")
        listVideo = DatabaseRealmManager.shared.listVideo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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

extension TabVideoViewController {
    func delete(item: VideoModel) -> Void {
        let alert = AlertController(title: "Are you sure delete this video?", message: "The video will lost", preferredStyle: .alert)
        alert.addAction(AlertAction(title: "Cancel", style: .normal))
        alert.addAction(AlertAction(title: "Delete", style: .destructive, handler: {[weak self] action in
            guard let self = self else { return }
            LoadingManager.show(in: self)
            DispatchQueue.main.async {
                DatabaseRealmManager.shared.removeVideo(idDatabase: item.IDDatabase)
            }
        }))
        alert.present()
    }
    
    @objc func clickMore(sender: UIButton!) {
        let video = listVideo[sender.tag]
        let alert = AlertController(title: "Choose your option", message: "\(video.desc)", preferredStyle: .actionSheet)
        
        alert.addAction(AlertAction(title: "Save video to camera roll", style: .normal, handler: {[weak self] action in
            guard let self = self else { return }
            LoadingManager.show(in: self)
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: FCFileManager.urlForItem(atPath: video.pathURL))
            }) { saved, error in
                LoadingManager.hide()
                if saved {
                    DispatchQueue.main.async {
                        Common.showAlert(type: kAlertType.success, title: "", content: "Save video to camera roll success !", completeActionTitle: "OK", cancelActionTitle: "", showCancelAction: false, completion: nil, close: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        Common.showAlert(content: "Can not save video to camera roll !")
                    }
                }
            }
        }))

        alert.addAction(AlertAction(title: "Share", style: .normal, handler: {[weak self] action in
            guard let self = self else { return }
            
            let videoURL = FCFileManager.urlForItem(atPath: video.pathURL)
            let objectsToShare: [Any] = [videoURL!, "Check this out !"]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                    popup.sourceView = self.view
                    popup.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                }
            }
            activityVC.modalPresentationStyle = .fullScreen
            self.present(activityVC, animated: true, completion: nil)
        }))
        
        alert.addAction(AlertAction(title: "Delete", style: .destructive, handler: {[weak self] action in
            guard let self = self else { return }
            self.delete(item: video)
        }))

        alert.addAction(AlertAction(title: "Cancel", style: .preferred))

        alert.present()
    }
}

extension TabVideoViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInset.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInset.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listVideo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
    UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
        
        if listVideo.count > 0 {
            let item = listVideo[indexPath.row]
            cell.configCell(video: item)
            cell.btnMore.tag = indexPath.row
            cell.btnMore.addTarget(self, action: #selector(clickMore), for: .touchUpInside)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = listVideo[indexPath.row]
        guard let videoURL = FCFileManager.urlForItem(atPath: item.pathURL)
        else { print("cannot play video!") ; return }
        let player = AVPlayer(url: videoURL)
        let vc = AVPlayerViewController()
        vc.player = player

        present(vc, animated: true) {
            vc.player?.play()
        }
    }
}

extension TabVideoViewController: GADBannerViewDelegate {
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

extension TabVideoViewController {
    
    @objc func createVideoSuccess(_ notification: Notification) {

    }
    
    @objc func deleteVideoSuccess(_ notification: Notification) {
        LoadingManager.hide()
        collectionView.reloadData()
    }
}
