//
//  TutorialViewController.swift
//  TikMate
//
//  Created by ChuoiChien on 12/24/20.
//

import UIKit

class TutorialViewController: BaseViewController {
    
    @IBOutlet weak var heightContraintView2: NSLayoutConstraint!
    @IBOutlet weak var heightContraintView3: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if IS_IPHONE_5_5S_SE {
            
        } else if IS_IPHONE_6_6S_7_8 {
            
        } else if IS_IPHONE_6PLUS_7PLUS_8PLUS {
            heightContraintView2.constant = 650
            heightContraintView3.constant = 650
        } else if IS_IPHONE_X_XS {
            
        } else if IS_IPHONE_XR_XSMAX_11 {
            heightContraintView2.constant = 650
            heightContraintView3.constant = 650
        } else {
            
        }
    }
    
    @IBAction func close(_ sender: Any) {        appDelegate?.rootViewController.dismissModalyWithoutAnimate(self, completion: nil)
    }

}
