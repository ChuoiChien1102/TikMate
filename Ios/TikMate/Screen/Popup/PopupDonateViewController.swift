//
//  PopupDonateViewController.swift
//  TikMate
//
//  Created by ChuoiChien on 12/22/20.
//

import UIKit

class PopupDonateViewController: BaseViewController {

    @IBOutlet weak var btnCheck: UIButton!
    var isCheck = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickCheck(_ sender: Any) {
        isCheck = !isCheck
        btnCheck.isSelected = !btnCheck.isSelected
    }
    
    @IBAction func clickOk(_ sender: Any) {
        appDelegate?.rootViewController.dismissModalyWithoutAnimate(self, completion: nil)
        IS_DONATE_COIN_NEWDAY.IS_SHOW = false
        UserDefaults.standard.set(isCheck, forKey: KEY_IS_NERVER_SHOW_POPUP)
    }
}
