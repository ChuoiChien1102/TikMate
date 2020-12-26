//
//  TabBarController.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var tabBarView = TabBarView()
    
    override func viewDidLoad() {
        self.tabBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(createVideoSuccess(_:)), name: NSNotification.Name(rawValue: NotificationCenterName.createVideoSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteVideoSuccess(_:)), name: NSNotification.Name(rawValue: NotificationCenterName.deleteVideoSuccess), object: nil)
        
        createTabbarViewControllers()
        
        if IS_IPHONE_5_5S_SE {
            tabBarView.frame = CGRect(x: 0, y: self.view.frame.size.height - 75 , width: WIDTH_DEVICE, height: 70)
        } else if IS_IPHONE_6_6S_7_8 {
            tabBarView.frame = CGRect(x: 0, y: self.view.frame.size.height - 100 , width: WIDTH_DEVICE, height: 70)
        } else if IS_IPHONE_6PLUS_7PLUS_8PLUS {
            tabBarView.frame = CGRect(x: 0, y: self.view.frame.size.height - 100 , width: WIDTH_DEVICE, height: 70)
        } else if IS_IPHONE_X_XS {
            tabBarView.frame = CGRect(x: 0, y: self.view.frame.size.height - 130 , width: WIDTH_DEVICE, height: 70)
        } else if IS_IPHONE_XR_XSMAX_11 {
            tabBarView.frame = CGRect(x: 0, y: self.view.frame.size.height - 130 , width: WIDTH_DEVICE, height: 70)
        } else {
            tabBarView.frame = CGRect(x: 0, y: self.view.frame.size.height - 130 , width: WIDTH_DEVICE, height: 70)
        }
        
        tabBarView.btnDownload.addTarget(self, action: #selector(self.clickTabDownLoad), for: .touchUpInside)
        tabBarView.btnVideo.addTarget(self, action: #selector(self.clickTabVideo), for: .touchUpInside)
        tabBarView.btnCoin.addTarget(self, action: #selector(self.clickTabCoin), for: .touchUpInside)
        
        self.view.addSubview(tabBarView)
        
        // set default tab is tabdownload
        selectedIndex = 0
        tabBarView.iconDownload.isSelected = true
        tabBarView.iconVideo.isSelected = false
        tabBarView.iconCoin.isSelected = false
        
        tabBarView.lbDownload.textColor = UIColor.green
        tabBarView.lbDownload.font = UIFont.systemFont(ofSize: 16.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
    }
}

extension TabBarController {
    func createTabbarViewControllers() -> Void {
        let listVideoDatabase = DatabaseRealmManager.shared.listVideo()
        if listVideoDatabase.count == 0 {
            viewControllers = [TabDownloadViewController.newInstance(), TabVideoTutorialViewController.newInstance(), TabCoinViewController.newInstance()]
        } else {
            viewControllers = [TabDownloadViewController.newInstance(), TabVideoViewController.newInstance(), TabCoinViewController.newInstance()]
        }
    }
    
    func updateTabbarViewControllers() -> Void {
        let listVideoDatabase = DatabaseRealmManager.shared.listVideo()
        if listVideoDatabase.count == 0 {
            viewControllers![1] = TabVideoTutorialViewController.newInstance()
        } else {
            viewControllers![1] = TabVideoViewController.newInstance()
        }
    }
    
    @objc func clickTabDownLoad(_ sender: UIButton) {
        selectedIndex = 0
        tabBarView.iconDownload.isSelected = true
        tabBarView.iconVideo.isSelected = false
        tabBarView.iconCoin.isSelected = false
        
        tabBarView.lbDownload.textColor = UIColor.green
        tabBarView.lbDownload.font = UIFont.systemFont(ofSize: 16.0)
        tabBarView.lbVideo.textColor = UIColor.black
        tabBarView.lbVideo.font = UIFont.systemFont(ofSize: 15.0)
        tabBarView.lbCoin.textColor = UIColor.black
        tabBarView.lbCoin.font = UIFont.systemFont(ofSize: 15.0)
    }
    
    @objc func clickTabVideo(_ sender: UIButton) {
        selectedIndex = 1
        tabBarView.iconDownload.isSelected = false
        tabBarView.iconVideo.isSelected = true
        tabBarView.iconCoin.isSelected = false
        
        tabBarView.lbVideo.textColor = UIColor.green
        tabBarView.lbVideo.font = UIFont.systemFont(ofSize: 16.0)
        tabBarView.lbDownload.textColor = UIColor.black
        tabBarView.lbDownload.font = UIFont.systemFont(ofSize: 15.0)
        tabBarView.lbCoin.textColor = UIColor.black
        tabBarView.lbCoin.font = UIFont.systemFont(ofSize: 15.0)
    }
    
    @objc func clickTabCoin(_ sender: UIButton) {
        selectedIndex = 2
        tabBarView.iconDownload.isSelected = false
        tabBarView.iconVideo.isSelected = false
        tabBarView.iconCoin.isSelected = true
        
        tabBarView.lbCoin.textColor = UIColor.green
        tabBarView.lbCoin.font = UIFont.systemFont(ofSize: 16.0)
        tabBarView.lbVideo.textColor = UIColor.black
        tabBarView.lbVideo.font = UIFont.systemFont(ofSize: 15.0)
        tabBarView.lbDownload.textColor = UIColor.black
        tabBarView.lbDownload.font = UIFont.systemFont(ofSize: 15.0)
    }
}

extension TabBarController {
    @objc func createVideoSuccess(_ notification: Notification) {
        updateTabbarViewControllers()
    }
    
    @objc func deleteVideoSuccess(_ notification: Notification) {
        updateTabbarViewControllers()
    }
}

