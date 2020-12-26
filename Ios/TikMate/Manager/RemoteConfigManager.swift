//
//  RemoteConfigManager.swift
//  TikMate
//
//  Created by ChuoiChien on 12/22/20.
//

import Foundation
import FirebaseRemoteConfig

enum RemoteConfigKey: String {
    case ios_tikmate_download_api_type = "ios_tikmate_download_api_type"
    case ios_tikmate_watch_video_reward = "ios_tikmate_watch_video_reward"
    case ios_tikmate_random_video_reward = "ios_tikmate_random_video_reward"
    case ios_tikmate_watch_interstitial = "ios_tikmate_watch_interstitial"
    case ios_tikmate_daily_coin = "ios_tikmate_daily_coin"
    case ios_tikmate_consumable_tinypack = "ios_tikmate_consumable_tinypack"
    case ios_tikmate_consumable_smallpack = "ios_tikmate_consumable_smallpack"
    case ios_tikmate_consumable_mediumpack = "ios_tikmate_consumable_mediumpack"
    case ios_tikmate_consumable_largepack = "ios_tikmate_consumable_largepack"
    case ios_tikmate_consumable_hugepack = "ios_tikmate_consumable_hugepack"
}

struct RemoteConfigManager {
    
    
    static var shared = RemoteConfigManager()
    fileprivate var remoteConfig: RemoteConfig
    
    fileprivate init() {
        self.remoteConfig = RemoteConfig.remoteConfig()
        #if DEBUG
        let remoteConfigSettings = RemoteConfigSettings()
        remoteConfigSettings.minimumFetchInterval = 0
        self.remoteConfig.configSettings = remoteConfigSettings
        #endif
    }
    
    func fetchRemoteConfig(completed: @escaping () -> Void) {
        let config = Common.getObjectFromUserDefault(KEY_FIR_REMOTE_CONFIG) as? FIRRemoteConfig
        if config != nil {
            FIRRemoteConfig.shared.ios_tikmate_download_api_type = config!.ios_tikmate_download_api_type
            FIRRemoteConfig.shared.ios_tikmate_watch_video_reward = config!.ios_tikmate_watch_video_reward
            FIRRemoteConfig.shared.ios_tikmate_random_video_reward = config!.ios_tikmate_random_video_reward
            FIRRemoteConfig.shared.ios_tikmate_watch_interstitial = config!.ios_tikmate_watch_interstitial
            FIRRemoteConfig.shared.ios_tikmate_daily_coin = config!.ios_tikmate_daily_coin
            FIRRemoteConfig.shared.ios_tikmate_consumable_tinypack = config!.ios_tikmate_consumable_tinypack
            FIRRemoteConfig.shared.ios_tikmate_consumable_smallpack = config!.ios_tikmate_consumable_smallpack
            FIRRemoteConfig.shared.ios_tikmate_consumable_mediumpack = config!.ios_tikmate_consumable_mediumpack
            FIRRemoteConfig.shared.ios_tikmate_consumable_largepack = config!.ios_tikmate_consumable_largepack
            FIRRemoteConfig.shared.ios_tikmate_consumable_hugepack = config!.ios_tikmate_consumable_hugepack
        }
        var expirationDuration = 0
        if self.remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 0
        }
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, _) in
            print("RemoteConfigManager fetchRemoteConfig status = \(status.rawValue)")
            if status == RemoteConfigFetchStatus.success {
                self.remoteConfig.activate(completionHandler: nil)
                FIRRemoteConfig.shared.ios_tikmate_download_api_type = self.remoteConfig.configValue(forKey: RemoteConfigKey.ios_tikmate_download_api_type.rawValue).stringValue!
                FIRRemoteConfig.shared.ios_tikmate_watch_video_reward = self.remoteConfig.configValue(forKey: RemoteConfigKey.ios_tikmate_watch_video_reward.rawValue).stringValue!
                FIRRemoteConfig.shared.ios_tikmate_random_video_reward = self.remoteConfig.configValue(forKey: RemoteConfigKey.ios_tikmate_random_video_reward.rawValue).stringValue!
                FIRRemoteConfig.shared.ios_tikmate_watch_interstitial = self.remoteConfig.configValue(forKey: RemoteConfigKey.ios_tikmate_watch_interstitial.rawValue).stringValue!
                FIRRemoteConfig.shared.ios_tikmate_daily_coin = self.remoteConfig.configValue(forKey: RemoteConfigKey.ios_tikmate_daily_coin.rawValue).stringValue!
                FIRRemoteConfig.shared.ios_tikmate_consumable_tinypack = self.remoteConfig.configValue(forKey: RemoteConfigKey.ios_tikmate_consumable_tinypack.rawValue).stringValue!
                FIRRemoteConfig.shared.ios_tikmate_consumable_smallpack = self.remoteConfig.configValue(forKey: RemoteConfigKey.ios_tikmate_consumable_smallpack.rawValue).stringValue!
                FIRRemoteConfig.shared.ios_tikmate_consumable_mediumpack = self.remoteConfig.configValue(forKey: RemoteConfigKey.ios_tikmate_consumable_mediumpack.rawValue).stringValue!
                FIRRemoteConfig.shared.ios_tikmate_consumable_largepack = self.remoteConfig.configValue(forKey: RemoteConfigKey.ios_tikmate_consumable_largepack.rawValue).stringValue!
                FIRRemoteConfig.shared.ios_tikmate_consumable_hugepack = self.remoteConfig.configValue(forKey: RemoteConfigKey.ios_tikmate_consumable_hugepack.rawValue).stringValue!
                print(" RemoteConfigManager RemoteConfigFetchStatus.success")
                
                Common.storeObjectToUserDefault(FIRRemoteConfig.shared, key: KEY_FIR_REMOTE_CONFIG)
            }
            completed()
        }
    }
}
