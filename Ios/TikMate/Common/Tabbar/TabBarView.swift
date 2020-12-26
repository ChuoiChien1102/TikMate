//
//  TabBarView.swift
//  VNPT-BRIS
//
//  Created by ChuoiChien on 12/9/20.
//  Copyright © 2020 VNPT. All rights reserved.
//

import UIKit

class TabBarView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var iconDownload: UIButton!
    @IBOutlet weak var iconVideo: UIButton!
    @IBOutlet weak var iconCoin: UIButton!
    
    @IBOutlet weak var lbDownload: UILabel!
    @IBOutlet weak var lbVideo: UILabel!
    @IBOutlet weak var lbCoin: UILabel!
    
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var btnCoin: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        
        // next: append the container to our view
        self.addSubview(self.containerView)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

}
