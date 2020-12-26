//
//  UserModel.swift
//  TikMate
//
//  Created by ChuoiChien on 12/20/20.
//

import UIKit

class UserModel: NSObject, NSCoding {
    var userId = ""
    var idToken = ""
    var fullName = ""
    var email = ""
    var coin = ""
    var last_online = ""
    var isVip = false
    
    static let share = UserModel()
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        if let userId = aDecoder.decodeObject(forKey: "userId") as? String {
            self.userId = userId
        }
        if let idToken = aDecoder.decodeObject(forKey: "idToken") as? String {
            self.idToken = idToken
        }
        if let fullName = aDecoder.decodeObject(forKey: "fullName") as? String {
            self.fullName = fullName
        }
        if let email = aDecoder.decodeObject(forKey: "email") as? String {
            self.email = email
        }
        if let coin = aDecoder.decodeObject(forKey: "coin") as? String {
            self.coin = coin
        }
        if let last_online = aDecoder.decodeObject(forKey: "last_online") as? String {
            self.last_online = last_online
        }
        if let isVip = aDecoder.decodeObject(forKey: "isVip") as? Bool {
            self.isVip = isVip
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userId, forKey: "userId")
        aCoder.encode(self.idToken, forKey: "idToken")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.coin, forKey: "coin")
        aCoder.encode(self.last_online, forKey: "last_online")
        aCoder.encode(self.isVip, forKey: "isVip")
    }
}
