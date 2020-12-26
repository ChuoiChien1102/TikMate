//
//  LoadingManager.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 12/4/20.
//

import Foundation
import JGProgressHUD

class LoadingManager: NSObject {
    
    static let hud = JGProgressHUD()
    static let hudDownload = JGProgressHUD()
    
    static func show( in vc: UIViewController ) {
        hud.textLabel.text = "Loading"
        hud.show(in: vc.view)
    }
    
    static func hide() {
        hud.dismiss(afterDelay: .init(0), animated: true)
    }
    
    
    static func success( in vc: UIViewController ) {
        let successHUD = JGProgressHUD()
        successHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
        successHUD.show(in: vc.view)
        successHUD.dismiss(afterDelay: 1.7)
    }
    
    static func showDownloading( in vc: UIViewController ) {
        NotificationCenter.default.addObserver(self, selector: #selector(updateDownloading(_:)), name: NSNotification.Name(rawValue: NotificationCenterName.dowloading), object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(0)) {
            hudDownload.vibrancyEnabled = true
            hudDownload.indicatorView = JGProgressHUDPieIndicatorView()
            hudDownload.detailTextLabel.text = "0% Complete"
            hudDownload.textLabel.text = "Downloading"
            hudDownload.show(in: vc.view)
        }
    }
}

extension LoadingManager {
    @objc static func updateDownloading(_ notification: Notification) {
        let value = notification.object as? Double
        let progress = round(Float(value!) * 100)
        hudDownload.progress = progress/100
        hudDownload.detailTextLabel.text = "\(progress)% Complete"
        
        if progress == 100 {
            NotificationCenter.default.removeObserver(self)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(0)) {
                UIView.animate(withDuration: 0.1, animations: {
                    hudDownload.textLabel.text = "Success"
                    hudDownload.detailTextLabel.text = nil
                    hudDownload.indicatorView = JGProgressHUDSuccessIndicatorView()
                })
                hudDownload.dismiss(afterDelay: 1.0)
            }
        }
    }
}
