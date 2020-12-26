//
//  UINavigationController+.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/10/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    convenience init(rootViewController: UIViewController, navigationBarClass: AnyClass?) {
        self.init(navigationBarClass: navigationBarClass, toolbarClass: nil)
        self.viewControllers = [rootViewController]
    }
}
