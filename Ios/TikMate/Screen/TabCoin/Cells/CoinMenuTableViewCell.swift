//
//  CoinMenuTableViewCell.swift
//  TikMate
//
//  Created by ChuoiChien on 12/22/20.
//

import UIKit

class CoinMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configUI(menu: CoinMenu) -> Void {
        icon.image = UIImage(named: menu.iconName)
        lbTitle.text = menu.name
        lbDetail.text = menu.detail
    }
    
}
