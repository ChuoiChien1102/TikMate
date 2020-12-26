//
//  Constants.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Foundation
import UIKit

enum KeysIAP {
    
    case ONE_WEEK, ONE_MONTH, THREE_MONTHS
    case ios_tikmate_consumable_tinypack, ios_tikmate_consumable_smallpack, ios_tikmate_consumable_mediumpack, ios_tikmate_consumable_largepack, ios_tikmate_consumable_hugepack
    case appSpecificSharedSecret
    
    var appId: String {
        switch self {
        case .appSpecificSharedSecret:
            return "93649a842fab4227bd53f1fc537a89de"
        // Subcription
        case .ONE_WEEK:
            return "com.thangnv.tikmate.subscription.weekly"
        case .ONE_MONTH:
            return "com.thangnv.tikmate.subscription.monthly"
        case .THREE_MONTHS:
            return "com.thangnv.tikmate.subscription.3months"
        // consumable
        case .ios_tikmate_consumable_tinypack:
            return "com.thangnv.tikmate.consumable.tinypack"
        case .ios_tikmate_consumable_smallpack:
            return "com.thangnv.tikmate.consumable.smallpack"
        case .ios_tikmate_consumable_mediumpack:
            return "com.thangnv.tikmate.consumable.mediumpack"
        case .ios_tikmate_consumable_largepack:
            return "com.thangnv.tikmate.consumable.largepack"
        case .ios_tikmate_consumable_hugepack:
            return "com.thangnv.tikmate.consumable.hugepack"
        }
    }
}

struct App {
    static let name: String = "TikMate"
    static let appID: String = "1544296992" //real
    static let ituneURL = "https://itunes.apple.com/us/app/id\(appID)"
//    static let BANNER_ADS_ID = "ca-app-pub-6252372722104773/3513632194"
//    static let INTERSTITIAL_ADS_ID = "ca-app-pub-6252372722104773/9895207714"
//    static let REWARD_ADS_ID = "ca-app-pub-6252372722104773/1793340501"
    static let BANNER_ADS_ID_TEST = "ca-app-pub-3940256099942544/2934735716"
    static let INTERSTITIAL_ADS_ID_TEST = "ca-app-pub-3940256099942544/5135589807"
    static let REWARD_ADS_ID_TEST = "ca-app-pub-3940256099942544/1712485313"
    static let policyLink = "https://sites.google.com/view/tikget/home"
}

struct Network {
    static let baseUrl = "https://tikmate.tk/"
}

/*********************
 Check width, height Screen
 ********************/
let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad

let WIDTH_DEVICE = UIScreen.main.bounds.size.width
let HEIGHT_DEVICE = UIScreen.main.bounds.size.height

let IS_IPHONE_5_5S_SE = (WIDTH_DEVICE == 320) && (HEIGHT_DEVICE == 568) && IS_IPHONE
let IS_IPHONE_6_6S_7_8 = (WIDTH_DEVICE == 375) && (HEIGHT_DEVICE == 667) && IS_IPHONE
let IS_IPHONE_6PLUS_7PLUS_8PLUS = (WIDTH_DEVICE == 414) && (HEIGHT_DEVICE == 736) && IS_IPHONE
let IS_IPHONE_X_XS = (WIDTH_DEVICE == 375) && (HEIGHT_DEVICE == 812) && IS_IPHONE
let IS_IPHONE_XR_XSMAX_11 = (WIDTH_DEVICE == 414) && (HEIGHT_DEVICE == 896) && IS_IPHONE

let KEY_IS_SKIP = "Skip"
let KEY_IS_PREMIUM = "Premium"
let KEY_USER_INFO = "userInfo"
let KEY_IS_NERVER_SHOW_POPUP = "KEY_IS_NERVER_SHOW_POPUP"
let KEY_FIR_REMOTE_CONFIG = "KEY_FIR_REMOTE_CONFIG"

struct IS_DONATE_COIN_NEWDAY {
    static var IS_DONATE = false
    static var IS_SHOW = true
}

struct FONT_DESCRIPTION_NAME {
    static let FONT_SYMBOL = "Symbol"
}

struct ERROR_CONNECTION{
    static let ERROR_NO_INTERNET = "Không có kết nối mạng. Kiểm tra lại kết nối mạng!"
    static let ERROR_HTTP_REQUEST = "Lỗi kết nối. Vui lòng thử lại"
}

struct FolderPath {
    static let video = ".video"
    static let database = "chuoichien1102"
}

enum kAlertType {
    case error
    case warning
    case success
    case progress
}

struct CoinConfig {
    static let downloadSuccess = 300
}

struct NotificationCenterName {
    static let createVideoSuccess = "createVideoSuccess"
    static let deleteVideoSuccess = "deleteVideoSuccess"
    static let dowloading = "dowloading"
}
