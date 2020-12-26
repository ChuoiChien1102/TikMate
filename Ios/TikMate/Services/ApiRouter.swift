//
//  ApiService.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
    case getLinkVideo([String: Any])
    
    // Http method
    private var method: HTTPMethod {
        switch self {
        case .getLinkVideo:
            return .get
        }
    }
    
    // path
    private var path: String {
        switch self {
        case .getLinkVideo(let param):
            return "ajax.php?search=\(param["urlString"] as! String)&type=urlPro&max=0"
        }
    }
    
    // paramater
    private var parameters: Parameters? {
        switch self {
        case .getLinkVideo(let paramater):
            return paramater
        }
    }
    
    // URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
//        let url = URL(string: Network.baseUrl)?.appendingPathComponent(path)
        let url = URL(string: Network.baseUrl).flatMap { URL(string: $0.absoluteString + path) }
        var urlRequest = URLRequest(url: url!)

        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let encoding = JSONEncoding.default
        let encoding = URLEncoding.queryString
        print("URL: ", try encoding.encode(urlRequest, with: parameters))
        return try encoding.encode(urlRequest, with: parameters)
//        return urlRequest
    }
}

