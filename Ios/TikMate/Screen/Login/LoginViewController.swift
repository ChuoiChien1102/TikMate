//
//  LoginViewController.swift
//  TikMate
//
//  Created by ChuoiChien on 12/22/20.
//

import UIKit
import GoogleSignIn
import Firebase
import LGSideMenuController

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var lbSignInPhone: UILabel!
    @IBOutlet weak var lbSignInGoogle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        lbSignInPhone.text = R.string.localizable.signInWithPhone()
        lbSignInGoogle.text = R.string.localizable.signInWithGoogle()
        
        // clientID get from file GoogleService-Info.plist
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    @IBAction func clickLoginWithPhone(_ sender: Any) {
        
    }
    
    @IBAction func clickLoginGoogle(_ sender: Any) {
        LoadingManager.show(in: self)
        GIDSignIn.sharedInstance()?.signIn()
    }
}

extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        // Check for sign in error
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            LoadingManager.hide()
            Common.showAlert(content: R.string.localizable.loginFailed())
            return
        }
        
        // Get credential object using Google ID token and Google access token
        guard let authentication = user.authentication else {
            LoadingManager.hide()
            Common.showAlert(content: R.string.localizable.loginFailed())
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        // Authenticate with Firebase using the credential object
        Auth.auth().signIn(with: credential) { (authResult, error) in
            LoadingManager.hide()
            if let error = error {
                print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
            } else {
                // user successfully sign in
                UserModel.share.userId = (authResult?.user.uid)!         // For client-side use only!
                UserModel.share.idToken = user.authentication.idToken // Safe to send to the server
                UserModel.share.fullName = user.profile.name
                UserModel.share.email = user.profile.email
                
                LoadingManager.show(in: self)
                DatabaseFireBaseManager.shared.fetchData {
                    DatabaseFireBaseManager.shared.removeObservers()
                    LoadingManager.hide()
                    // check IAP, verify subcription package
                    PurchaserManager.completeTransactions {
                        // Code
                        let leftMennu = MenuViewController.newInstance()
                        let sideMenuController = LGSideMenuController(rootViewController: TabBarController(),
                                                                      leftViewController: leftMennu,
                                                                      rightViewController: nil)
                        sideMenuController.leftViewWidth = WIDTH_DEVICE * 2/3
                        sideMenuController.leftViewPresentationStyle = .slideBelow
                        self.appDelegate?.changeRootViewController(sideMenuController)
                    }
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        LoadingManager.hide()
        Common.showAlert(content: R.string.localizable.canNotLoginByGoogleAccount())
    }
}
