//
//  UIViewController+.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    var appDelegate: AppDelegate? {
        
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return app
    }
}
