//
//  DatabaseRealmManager.swift
//  TikMate
//
//  Created by ChuoiChien on 12/17/20.
//

import Foundation
import Realm
import RealmSwift
import FCFileManager

class DatabaseRealmManager: NSObject {
        
    static let shared = DatabaseRealmManager()
    
    let realm = try! Realm()
    
    class func setup() {
        
        let dbConfig = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = dbConfig
        
        var config = Realm.Configuration()
        FCFileManager.createDirectories(forPath: FolderPath.database)
        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(FolderPath.database)/chien.realm")
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
    
    //MARK:- Create
    
    //From local
    func create( video: VideoModel ) {
        
        let videoDB = TBVideo()
        videoDB.IDDatabase = UUID.init().uuidString.lowercased()
        videoDB.date = Date()
        videoDB.IDVideo = video.ID
        videoDB.IDUser = UserModel.share.userId
        videoDB.desc = video.desc
        videoDB.coverImage = video.coverImage
        videoDB.detailURL = video.detailURL
        videoDB.downloadURL = video.downloadURL
        videoDB.isPremium = false
        videoDB.pathURL = video.pathURL
        DispatchQueue.main.async {
            try! self.realm.write {
                print("Create video success")
                self.realm.add(videoDB, update: .modified)
            }
            
            NotificationCenter.default.post(name: Notification.Name(NotificationCenterName.createVideoSuccess), object: nil)
        }
    }
    
    //MARK:- Delete
    func removeVideo(idDatabase: String) {
        
        guard let ringtone = realm.objects(TBVideo.self).filter({$0.IDDatabase == idDatabase}).first else { return }
        
        DispatchQueue.main.async {
            
            try! self.realm.write {
                print("Delete video success")
                self.realm.delete(ringtone)
            }
            
            NotificationCenter.default.post(name: Notification.Name(NotificationCenterName.deleteVideoSuccess), object: nil)
        }
    }
    
    //MARK:- List
    
    
    func listVideo() -> [VideoModel] {

        
        var listData:[VideoModel] = []
        
        let listVideo = realm.objects(TBVideo.self).filter {$0.isPremium == false && $0.IDUser == UserModel.share.userId}.sorted {$0.date > $1.date}
        
        for item in listVideo {
            let vd = VideoModel.init()
            vd.IDDatabase = item.IDDatabase
            vd.ID = item.IDVideo
            vd.desc = item.desc
            vd.coverImage = item.coverImage
            vd.detailURL = item.detailURL
            vd.downloadURL = item.downloadURL
            vd.pathURL = item.pathURL
            
            listData.append(vd)
        }
        
        return listData

    }
    
    
}
