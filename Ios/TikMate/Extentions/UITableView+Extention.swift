//
//  UITableView+.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/10/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
    
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
}
