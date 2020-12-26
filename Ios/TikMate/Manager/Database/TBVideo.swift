//
//  TBVideo.swift
//  TikMate
//
//  Created by ChuoiChien on 12/17/20.
//

import Foundation
import Realm
import RealmSwift

class TBVideo : Object {
    
    @objc dynamic var IDDatabase: String = "0"
    @objc dynamic var IDVideo: String = ""
    @objc dynamic var IDUser: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var coverImage: String = ""
    @objc dynamic var detailURL: String = ""
    @objc dynamic var downloadURL: String = ""
    @objc dynamic var pathURL: String = ""
    @objc dynamic var date: Date = Date() //Saved date
    
    @objc dynamic var isPremium: Bool = false

    override class func primaryKey() -> String? {
        return "IDDatabase"
    }

}
