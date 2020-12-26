//
//  SplashViewController.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 12/5/20.
//

import UIKit
import Firebase
import LGSideMenuController

class SplashViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LoadingManager.show(in: self)
        DatabaseFireBaseManager.shared.fetchData {
            DatabaseFireBaseManager.shared.removeObservers()
            LoadingManager.hide()
            // check IAP, verify subcription package
            PurchaserManager.completeTransactions {
                // Code
                let leftMennu = MenuViewController.newInstance()
                let sideMenuController = LGSideMenuController(rootViewController: TabBarController(),
                                                              leftViewController: leftMennu,
                                                              rightViewController: nil)
                sideMenuController.leftViewWidth = WIDTH_DEVICE * 2/3
                sideMenuController.leftViewPresentationStyle = .slideBelow
                self.appDelegate?.changeRootViewController(sideMenuController)
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
}
