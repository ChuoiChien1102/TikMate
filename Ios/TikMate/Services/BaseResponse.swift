//
//  BaseResponse.swift
//  VNPT-BRIS
//
//  Created by ERP-PM2-1174 on 3/30/20.
//  Copyright © 2020 VNPT. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponse: Mappable {
    
    var statusCode: Int?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        statusCode <- (map["statusCode"])
    }
}

