//
//  Common.swift
//  TikMate
//
//  Created by ChuoiChien on 12/18/20.
//

import UIKit
import Photos
import FCAlertView
import ObjectMapper

class Common {
    
    static func showAlert(type: kAlertType = .error,
                          title: String = R.string.localizable.alert(),
                          content: String,
                          completeActionTitle: String = R.string.localizable.oK(),
                          cancelActionTitle: String = R.string.localizable.close(),
                          showCancelAction: Bool = false,
                          completion: (() -> Void)? = nil,
                          close: (() -> Void)? = nil) {
        
        let alert = FCAlertView()
        
        switch type {
        case .error:
            alert.makeAlertTypeWarning()
            break
        case .warning:
            alert.makeAlertTypeCaution()
            break
        case .success:
            alert.makeAlertTypeSuccess()
        case .progress:
            alert.makeAlertTypeProgress()
        }
        
        if showCancelAction {
            alert.addButton(cancelActionTitle) {
                if close != nil {
                    close!()
                }
            }
        }
        
        alert.doneBlock = {
            if completion != nil {
                completion!()
            }
        }
        
        alert.showAlert(withTitle: title,
                        withSubtitle: content,
                        withCustomImage: nil,
                        withDoneButtonTitle: completeActionTitle,
                        andButtons: nil)
    }
    
    static func storeObjectToUserDefault(_ object: AnyObject, key: String) {
        let dataSave = NSKeyedArchiver.archivedData(withRootObject: object)
        UserDefaults.standard.set(dataSave, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func getObjectFromUserDefault(_ key: String) -> AnyObject? {
        if let object = UserDefaults.standard.object(forKey: key) {
            return NSKeyedUnarchiver.unarchiveObject(with: object as! Data) as AnyObject?
        }
        
        return nil
    }
    
    static func removeObjectForKey(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func removeAllValueUserDefault() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
    
    // output DD-MM-YYYY
    static func getStringFromDate() -> String {
        let dateFormatter = DateFormatter()
        let date = NSDate()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date as Date)
        let startOfMonth = calendar.date(from: components)

        let currentDate = dateFormatter.string(from: startOfMonth!)
        return currentDate
    }
    
    static func convertStringToDate(_ strDate: String,_ formatter: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        dateFormatter.locale = .none
        dateFormatter.timeZone = TimeZone(secondsFromGMT: +9)!
        return dateFormatter.date(from: strDate)!
    }
}
