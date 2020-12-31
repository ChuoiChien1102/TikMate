//
//  DatabaseFireBaseManager.swift
//  TikMate
//
//  Created by ChuoiChien on 12/22/20.
//

import UIKit
import FirebaseDatabase

class DatabaseFireBaseManager: NSObject {
    let rootRef = Database.database().reference(fromURL: "https://tikget-fd170.firebaseio.com/tikget/account/")
    static let shared = DatabaseFireBaseManager()
    
    func fetchData(completed: @escaping () -> Void) {
        
        rootRef.child("\(UserModel.share.userId)").observe(DataEventType.value, with: { (snapshot) in
            if snapshot.value is  Dictionary<String, Any> {
                let dic = snapshot.value as! Dictionary<String, Any>
                UserModel.share.coin = String((dic["coin"] as? Int)!)
                UserModel.share.last_online = (dic["last_online"] as? String)!
                UserModel.share.isVip = (dic["vip"] as? Bool)!
                
                Common.storeObjectToUserDefault(UserModel.share, key: KEY_USER_INFO)
                let date = Common.convertStringToDate(UserModel.share.last_online, "dd-MM-yyyy")
                let isToday = Calendar.current.isDateInToday(date)
                if isToday == false {
                    IS_DONATE_COIN_NEWDAY.IS_DONATE = true
                    if Int(UserModel.share.coin)! < Int(FIRRemoteConfig.shared.ios_tikmate_daily_coin)! {
                        UserModel.share.coin = FIRRemoteConfig.shared.ios_tikmate_daily_coin
                        self.postChangeUserCoin()
                    }
                }
            } else {
                self.createUserFirebase()
            }
            
            completed()
        })
    }
    func createUserFirebase() -> Void {
        var dict = [String: Any]()
        dict["coin"] = Int(FIRRemoteConfig.shared.ios_tikmate_daily_coin)
        dict["last_online"] = Common.getStringFromDate()
        dict["vip"] = false
        rootRef.child(UserModel.share.userId).setValue(dict)
    }
    func postChangeUserLastOnline() -> Void {
        var dict = [String: Any]()
        dict["last_online"] = UserModel.share.last_online
        rootRef.child(UserModel.share.userId).updateChildValues(dict)
        Common.storeObjectToUserDefault(UserModel.share, key: KEY_USER_INFO)
    }
    func postChangeUserCoin() -> Void {
        var dict = [String: Any]()
        dict["coin"] = Int(UserModel.share.coin)
        rootRef.child(UserModel.share.userId).updateChildValues(dict)
        Common.storeObjectToUserDefault(UserModel.share, key: KEY_USER_INFO)
    }
    func postChangeUserIsVip() -> Void {
        var dict = [String: Any]()
        dict["vip"] = UserModel.share.isVip
        rootRef.child(UserModel.share.userId).updateChildValues(dict)
        Common.storeObjectToUserDefault(UserModel.share, key: KEY_USER_INFO)
    }
    func removeObservers() -> Void {
        let current = self.rootRef.child(UserModel.share.userId)
        current.removeAllObservers()
    }
}
