//
//  ApiSevice.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireObjectMapper

class ApiSevice {
    static func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    static func getLinkVideo(_ param: [String:Any], completion: @escaping (VideoResponse?, BaseError?) -> Void) -> Void {
        if !isConnectedToInternet() {
            // Xử lý khi lỗi kết nối internet
            
            return
        }
        Alamofire.request(ApiRouter.getLinkVideo(param)).responseObject { (response: DataResponse<VideoResponse>) in
            
            switch response.result {
            case .success:
                // print log response
                let json = try? JSONSerialization.jsonObject(with: response.data!, options: [])
                if json != nil {
                    print(json!)
                }
                
                if response.response?.statusCode == 200 {
                    completion(response.result.value, nil)
                } else {
                    let err: BaseError = BaseError.init(NetworkErrorType.HTTP_ERROR, (response.response?.statusCode)!, ERROR_CONNECTION.ERROR_HTTP_REQUEST)
                    completion(nil, err)
                }
                break
                
            case .failure(let error):
                let err: BaseError = BaseError.init(NetworkErrorType.HTTP_ERROR, error._code, ERROR_CONNECTION.ERROR_HTTP_REQUEST)
                completion(nil, err)
                break
            }
        }
    }
    
    static func downloadFile(fileURL: URL, fileName: String, completionHandler:@escaping(String, Bool)->()){

        let destinationPath: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0];
            let filePath = documentsURL.appendingPathComponent(FolderPath.video + "/" + fileName + ".mp4")
            return (filePath, [.removePreviousFile, .createIntermediateDirectories])
        }
    
        Alamofire.download(fileURL, to: destinationPath)
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
                NotificationCenter.default.post(name: Notification.Name(NotificationCenterName.dowloading), object: progress.fractionCompleted)
            }
            .responseData { response in
                print("download response: \(response)")
                switch response.result{
                case .success:
                    if response.destinationURL != nil, let filePath = response.destinationURL?.absoluteString {
                        completionHandler(filePath, true)
                    }
                    break
                case .failure:
                    completionHandler("", false)
                    break
                }

        }
    }
    
}
