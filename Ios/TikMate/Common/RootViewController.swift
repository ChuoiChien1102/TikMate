//
//  RootViewController.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    private var firstViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // default root view controller is TabbarController
    func setRootView(_ vc: UIViewController? = nil) {
        
        if let cvc = firstViewController {
            cvc.willMove(toParent: nil)
            cvc.view.removeFromSuperview()
            cvc.removeFromParent()
        }
        
        if let firstVC = vc {
            firstViewController =  firstVC
        }
        
        guard let cvc = firstViewController else {
            fatalError("firstViewController must be not null.")
        }
        
        addChild(cvc)
        view.addSubview(cvc.view)
        cvc.didMove(toParent: self)
        
    }
    
    func presentModaly(_ toViewController: UIViewController) {
        self.addChild(toViewController)
        self.view.addSubview(toViewController.view)
        
        toViewController.view.transform = CGAffineTransform(translationX: 0.0, y: self.view.bounds.height)
        
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
            toViewController.view.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
        }, completion: { (_) in
            toViewController.didMove(toParent: self)
        })
    }
    
    func dismissModaly(_ fromViewController: UIViewController?) {
        guard let fvc = fromViewController ?? children.last else {
            fatalError("No UIViewControllers can dismiss.")
        }
        
        fvc.view.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
        
        fvc.willMove(toParent: nil)
        
        UIView.animate(withDuration: 0.4, animations: {
            fvc.view.transform = CGAffineTransform(translationX: 0.0, y: (self.view.bounds.height))
        },
                       completion: { (_) in
                        fvc.view.removeFromSuperview()
                        fvc.removeFromParent()
        })
    }
    
    func presentModalyWithoutAnimate(_ toViewController: UIViewController) {
        self.addChild(toViewController)
        self.view.addSubview(toViewController.view)
        toViewController.didMove(toParent: self)
    }
    
    func dismissModalyWithoutAnimate(_ fromViewController: UIViewController?, completion: (() -> Void)?) {
        guard let fvc = fromViewController ?? children.last else {
            fatalError("No UIViewControllers can dismiss.")
        }
        fvc.view.removeFromSuperview()
        fvc.removeFromParent()
        if completion != nil {
            completion!()
        }
    }
    
    func dismissChilds(animated: Bool) {
        if animated {
            let middleChilds = children.dropLast().dropFirst()
            middleChilds.forEach {
                $0.view.removeFromSuperview()
                $0.removeFromParent()
            }
            dismissModaly(children.last)
        } else {
            let childs = children.dropLast().dropFirst()
            childs.forEach {
                $0.view.removeFromSuperview()
                $0.removeFromParent()
            }
            dismissModalyWithoutAnimate(children.last, completion: nil)
        }
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return children.last?.childForStatusBarStyle
    }
    
    override open var childForStatusBarHidden: UIViewController? {
        return children.last?.childForStatusBarHidden
    }
}
