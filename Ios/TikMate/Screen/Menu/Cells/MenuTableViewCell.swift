//
//  MenuTableViewCell.swift
//  BRIS
//
//  Created by ChuoiChien on 9/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var iconMenu: UIImageView!
    @IBOutlet weak var titleMenu: UILabel!
    
    var section: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configUI(menu: Menu) -> Void {
        iconMenu.image = UIImage(named: menu.iconName)
        titleMenu.text = menu.name
    }
}
