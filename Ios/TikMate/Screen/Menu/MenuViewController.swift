//
//  MenuViewController.swift
//  TikMate
//
//  Created by ChuoiChien on 12/20/20.
//

import UIKit
import GoogleSignIn
import Firebase
import SwiftRater
import SafariServices
import MessageUI

class Menu: NSObject {
    var iconName = ""
    var name = ""
}

class MenuViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayMenu = [Menu]()
    
    let HEIGHT_ROW_NOMARL    = 60
    let HEIGHT_ROW_PROFILE    = 90
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
}

extension MenuViewController {
    func setupUI() -> Void {
        tableView.registerCellNib(ProfileTableViewCell.self)
        tableView.registerCellNib(MenuTableViewCell.self)
        
        tableView.separatorStyle = .none
    }
    
    func setupData() -> Void {
        let profile = Menu()
        profile.name = "Profile"
        arrayMenu.append(profile)
        
        let policy = Menu()
        policy.name = R.string.localizable.privacyPolicy()
        policy.iconName = "ic_info"
        arrayMenu.append(policy)
        
        let buyCoin = Menu()
        buyCoin.name = R.string.localizable.buyCoin()
        buyCoin.iconName = "ic_buy_coin"
        arrayMenu.append(buyCoin)
        
        let howToUse = Menu()
        howToUse.name = R.string.localizable.howToUse()
        howToUse.iconName = "ic_use"
        arrayMenu.append(howToUse)
        
        let share = Menu()
        share.name = R.string.localizable.share()
        share.iconName = "ic_share"
        arrayMenu.append(share)
        
        let feedback = Menu()
        feedback.name = R.string.localizable.feedback()
        feedback.iconName = "ic_feedback"
        arrayMenu.append(feedback)
        
        let rate = Menu()
        rate.name = R.string.localizable.rateThisApp()
        rate.iconName = "ic_rate"
        arrayMenu.append(rate)
        
        let moreApp = Menu()
        moreApp.name = R.string.localizable.moreApp()
        moreApp.iconName = "ic_more_app"
        arrayMenu.append(moreApp)
        
        let logout = Menu()
        logout.name = R.string.localizable.logOut()
        logout.iconName = "ic_logout"
        arrayMenu.append(logout)
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // profile
            let cell = tableView.dequeueReusableCell(withIdentifier: String.className(ProfileTableViewCell.self)) as! ProfileTableViewCell
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String.className(MenuTableViewCell.self)) as! MenuTableViewCell
            
            let item = arrayMenu[indexPath.row]
            cell.configUI(menu: item)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0 {
            return CGFloat(HEIGHT_ROW_PROFILE)
        }
        return CGFloat(HEIGHT_ROW_NOMARL)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            // privacy policy
            if let url = URL(string: App.policyLink) {
                if #available(iOS 11.0, *) {
                    let config = SFSafariViewController.Configuration()
                    config.entersReaderIfAvailable = true
                    let vc = SFSafariViewController(url: url, configuration: config)
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        case 2:
            // buy coin
            appDelegate?.rootViewController.presentModalyWithoutAnimate(BuyCoinViewController.newInstance())
            break
        case 3:
            // guide
            appDelegate?.rootViewController.presentModalyWithoutAnimate(TutorialViewController.newInstance())
            break
        case 4:
            // share app
            if let urlStr = NSURL(string: App.ituneURL) {
                let objectsToShare = [urlStr]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    if let popup = activityVC.popoverPresentationController {
                        popup.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                        popup.sourceView = self.view
                        popup.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                    }
                }
                activityVC.modalPresentationStyle = .fullScreen
                self.present(activityVC, animated: true, completion: nil)
            }
            break
        case 5:
            // feedback
            sendEmail()
            break
        case 6:
            // rate
            SwiftRater.rateApp(host: self)
            break
        case 8:
            // log out
            Common.showAlert(type: kAlertType.warning, title: R.string.localizable.confirm(), content: R.string.localizable.doYouWantToLogOut(), completeActionTitle: R.string.localizable.oK(), cancelActionTitle: R.string.localizable.cancle(), showCancelAction: true) {
                self.logout()
            } close: {
                
            }
            
            break
        default:
            break
        }
    }
}

extension MenuViewController {
    func logout() -> Void {
        GIDSignIn.sharedInstance()?.signOut()
        // Sign out from Firebase
        do {
            try Auth.auth().signOut()
            
            // Update screen after user successfully signed out
            Common.removeAllValueUserDefault()
            appDelegate?.changeRootViewController(LoginViewController.newInstance())
        } catch let error as NSError {
            print ("Error signing out from Firebase: %@", error)
        }
    }
}

extension MenuViewController: MFMailComposeViewControllerDelegate {
    func sendEmail() {
        // Modify following variables with your text / recipient
        let recipientEmail = "test@email.com"
        let subject = "Multi client email support"
        let body = "This code supports sending email via multiple different email apps on iOS! :)"
        
        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            
            present(mail, animated: true)
            
            // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
        
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
