//
//  NavigationBar.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/10/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import UIKit

class NavigationBar: UINavigationBar {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNavigationBarAppearance()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNavigationBarAppearance()
    }
    
    private func setupNavigationBarAppearance() {
        self.isTranslucent = false
        self.barTintColor = UIColor.init(hex: "#1876F2")
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: FONT_DESCRIPTION_NAME.FONT_SYMBOL, size: 18.0)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
    
        // set image for backItem
        let  backButtonImage = UIImage(named: "ic_back")
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
    }
    
    override func layoutSubviews() {
        // hidden backItem default
        topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        super.layoutSubviews()
    }
}

