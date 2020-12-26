//
//  BaseViewController.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 10/22/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        dissmissKeyboardWhenTapOutside()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("BaseViewController : \(type(of: self))")
    }
    
    // dissmiss keyboard when tap outside input (textField, textView...)
    func dissmissKeyboardWhenTapOutside() -> Void {
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleSingleTap(_:)))
        tapRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapRecognizer)
        self.navigationController?.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func handleSingleTap(_ sender: UITapGestureRecognizer) -> Void {
        self.view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
