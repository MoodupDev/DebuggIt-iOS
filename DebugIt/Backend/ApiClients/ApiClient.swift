//
//  ApiClient.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 04.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ApiClient {
    static func upload(_ type: MediaType, data base64EncodedString: String, successBlock: @escaping () -> (), errorBlock: @escaping (_ statusCode: Int?, _ errorMessage: String?) -> ()) {
        var url: String
        switch type {
        case .image:
            url = Constants.Api.uploadImageUrl
        default:
            url = Constants.Api.uploadAudioUrl
        }
        
        let params : Parameters = [
            "data": base64EncodedString,
            "app_id": Bundle.main.bundleIdentifier ?? ""
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let value = JSON(value)
                if response.isSuccess() {
                    DebuggIt.sharedInstance.report.screenshotsUrl.append(value["url"].stringValue)
                    print(value["url"].stringValue)
                    successBlock()
                } else {
                    errorBlock(response.responseCode, value.rawString())
                }
            case .failure(let error as AFError):
                errorBlock(nil, error.errorDescription)
            default:
                errorBlock(nil, nil)
                
            }
            
        }
        
    }
    
    static func postEvent(_ event: EventType, value: Int? = nil) {
        
        // TODO: update api names to consume system name such as "android" or "ios" and system version
        
        var params: Parameters = [
            "event_type": event.name(),
            "app_id": Bundle.main.bundleIdentifier ?? "",
            "android_sdk": UIDevice.current.systemVersion,
            "device": UIDevice.current.modelName
        ]
        if value != nil {
            params["value"] = value
        }
        
        Alamofire.request(Constants.Api.eventsUrl, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).response { (response) in
            print(response)
        }
        
    }
    
    static func checkVersion() {
        // TODO: implement checking if version is supported
    }
}

extension ApiClient {
    
    enum MediaType {
        case image
        case audio
    }
}
