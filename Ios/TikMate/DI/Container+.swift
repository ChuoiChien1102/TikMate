//
//  Container+.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//



import Swinject

extension Container {
    static let shareResolver = Assembler([
        
        //Base Assembly
        RootVCAssembly(),
        ApiSeviceAssembly(),
        
        //ViewController
        SplashViewControllerAssembly(),
        LoginViewControllerAssembly(),
        MenuViewControllerAssembly(),
        TabDownloadViewControllerAssembly(),
        TabVideoViewControllerAssembly(),
        TabVideoTutorialViewControllerAssembly(),
        TabCoinViewControllerAssembly(),
        PopupDonateViewControllerAssembly(),
        PopupWarningViewControllerAssembly(),
        TutorialViewControllerAssembly(),
        BuyCoinViewControllerAssembly(),
        BuyVipViewControllerAssembly(),
        
        ]).resolver
}
