//
//  FIRRemoteConfig.swift
//  TikMate
//
//  Created by ChuoiChien on 12/22/20.
//

import UIKit

import UIKit

class FIRRemoteConfig: NSObject, NSCoding {
    var ios_tikmate_download_api_type = "1"
    var ios_tikmate_watch_video_reward = "500"
    var ios_tikmate_random_video_reward = "250"
    var ios_tikmate_watch_interstitial = "150"
    var ios_tikmate_daily_coin = "1000"
    var ios_tikmate_consumable_tinypack = "1200"
    var ios_tikmate_consumable_smallpack = "2800"
    var ios_tikmate_consumable_mediumpack = "8000"
    var ios_tikmate_consumable_largepack = "20000"
    var ios_tikmate_consumable_hugepack = "125000"
    
    static let shared = FIRRemoteConfig()
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        if let ios_tikmate_download_api_type = aDecoder.decodeObject(forKey: "ios_tikmate_download_api_type") as? String {
            self.ios_tikmate_download_api_type = ios_tikmate_download_api_type
        }
        if let ios_tikmate_watch_video_reward = aDecoder.decodeObject(forKey: "ios_tikmate_watch_video_reward") as? String {
            self.ios_tikmate_watch_video_reward = ios_tikmate_watch_video_reward
        }
        if let ios_tikmate_random_video_reward = aDecoder.decodeObject(forKey: "ios_tikmate_random_video_reward") as? String {
            self.ios_tikmate_random_video_reward = ios_tikmate_random_video_reward
        }
        if let ios_tikmate_watch_interstitial = aDecoder.decodeObject(forKey: "ios_tikmate_watch_interstitial") as? String {
            self.ios_tikmate_watch_interstitial = ios_tikmate_watch_interstitial
        }
        if let ios_tikmate_daily_coin = aDecoder.decodeObject(forKey: "ios_tikmate_daily_coin") as? String {
            self.ios_tikmate_daily_coin = ios_tikmate_daily_coin
        }
        if let ios_tikmate_consumable_tinypack = aDecoder.decodeObject(forKey: "ios_tikmate_consumable_tinypack") as? String {
            self.ios_tikmate_consumable_tinypack = ios_tikmate_consumable_tinypack
        }
        if let ios_tikmate_consumable_smallpack = aDecoder.decodeObject(forKey: "ios_tikmate_consumable_smallpack") as? String {
            self.ios_tikmate_consumable_smallpack = ios_tikmate_consumable_smallpack
        }
        if let ios_tikmate_consumable_mediumpack = aDecoder.decodeObject(forKey: "ios_tikmate_consumable_mediumpack") as? String {
            self.ios_tikmate_consumable_mediumpack = ios_tikmate_consumable_mediumpack
        }
        if let ios_tikmate_consumable_largepack = aDecoder.decodeObject(forKey: "ios_tikmate_consumable_largepack") as? String {
            self.ios_tikmate_consumable_largepack = ios_tikmate_consumable_largepack
        }
        if let ios_tikmate_consumable_hugepack = aDecoder.decodeObject(forKey: "ios_tikmate_consumable_hugepack") as? String {
            self.ios_tikmate_consumable_hugepack = ios_tikmate_consumable_hugepack
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.ios_tikmate_download_api_type, forKey: "ios_tikmate_download_api_type")
        aCoder.encode(self.ios_tikmate_watch_video_reward, forKey: "ios_tikmate_watch_video_reward")
        aCoder.encode(self.ios_tikmate_random_video_reward, forKey: "ios_tikmate_random_video_reward")
        aCoder.encode(self.ios_tikmate_watch_interstitial, forKey: "ios_tikmate_watch_interstitial")
        aCoder.encode(self.ios_tikmate_daily_coin, forKey: "ios_tikmate_daily_coin")
        aCoder.encode(self.ios_tikmate_consumable_tinypack, forKey: "ios_tikmate_consumable_tinypack")
        aCoder.encode(self.ios_tikmate_consumable_smallpack, forKey: "ios_tikmate_consumable_smallpack")
        aCoder.encode(self.ios_tikmate_consumable_mediumpack, forKey: "ios_tikmate_consumable_mediumpack")
        aCoder.encode(self.ios_tikmate_consumable_largepack, forKey: "ios_tikmate_consumable_largepack")
        aCoder.encode(self.ios_tikmate_consumable_hugepack, forKey: "ios_tikmate_consumable_hugepack")
    }
}
