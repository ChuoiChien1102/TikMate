//
//  VideoResponse.swift
//  VNPT-BRIS
//
//  Created by ChuoiChien on 12/2/20.
//  Copyright © 2020 VNPT. All rights reserved.
//

import UIKit
import ObjectMapper

class VideoResponse: BaseResponse {
    
    var info = [String: Any]()
    var items = [[String: Any]]()
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        info <- map["info"]
        items <- map["items"]
    }
}

class VideoModel: NSObject {
    
    var ID = ""
    var IDDatabase = ""
    var desc = ""
    var coverImage = ""
    var detailURL = ""
    var downloadURL = ""
    var pathURL = ""
}
