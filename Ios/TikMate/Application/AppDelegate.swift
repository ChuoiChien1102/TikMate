//
//  AppDelegate.swift
//  TikMate
//
//  Created by ChuoiChien on 12/14/20.
//

import UIKit
import Firebase
import LGSideMenuController
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootViewController = RootViewController.newInstance()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // fetch value config from firebase
        RemoteConfigManager.shared.fetchRemoteConfig {
            // Code
        }
        
        let user = Common.getObjectFromUserDefault(KEY_USER_INFO) as? UserModel
        if user == nil {
            let vc = LoginViewController.newInstance()
            rootViewController.setRootView(vc)
        } else {
            UserModel.share.userId = user!.userId
            UserModel.share.idToken = user!.idToken
            UserModel.share.fullName = user!.fullName
            UserModel.share.email = user!.email
            UserModel.share.coin = user!.coin
            UserModel.share.isVip = user!.isVip
        
            let vc = SplashViewController.newInstance()
            rootViewController.setRootView(vc)
        }
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

extension AppDelegate {
    func changeRootViewController(_ viewController: UIViewController? = nil) {
        rootViewController = RootViewController.newInstance()
        rootViewController.setRootView(viewController)
        window?.rootViewController = rootViewController
    }
}
