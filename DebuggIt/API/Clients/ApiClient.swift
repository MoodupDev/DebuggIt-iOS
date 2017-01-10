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
                    let url = value["url"].stringValue
                    switch(type) {
                    case .image:
                        let screenName = DebuggIt.sharedInstance.report.currentScreenshotScreenName!
                        DebuggIt.sharedInstance.report.screenshots.append(Screenshot(screenName: screenName, url: url))
                    case .audio:
                        DebuggIt.sharedInstance.report.audioUrls.append(url)
                    }
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
        
        var params: Parameters = [
            "event_type": event.name(),
            "app_id": Bundle.main.bundleIdentifier ?? "",
            "system_version": UIDevice.current.systemVersion,
            "system": "ios",
            "device": UIDevice.current.modelName
        ]
        if value != nil {
            params["value"] = value
        }
        
        Alamofire.request(Constants.Api.eventsUrl, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).response { (response) in
        }
        
    }
    
    static func checkVersion(completionHandler: @escaping (_ isChecked: Bool, _ isSupported: Bool) -> ()) {
        if let version = Initializer.bundle(forClass: ApiClient.self).infoDictionary?["CFBundleShortVersionString"] as? String {
            Alamofire.request(String(format: Constants.Api.supportedVersionUrl, version)).responseData { response in
                switch response.result {
                case .success(_):
                    completionHandler(true, response.isSuccess())
                case .failure(_):
                    completionHandler(false, false)
                }
            }
        } else {
            completionHandler(false, false)
        }
    }
}

extension ApiClient {
    
    enum MediaType {
        case image
        case audio
    }
}
