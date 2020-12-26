//
//  DKEventsManager.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 12/13/20.
//

import Foundation
import Firebase


class DKEventsManager: NSObject {
    
    class func log(_ eventName: String, _ params: [String: Any]) {
        
        Analytics.logEvent(eventName, parameters: params)
    }
    
}


