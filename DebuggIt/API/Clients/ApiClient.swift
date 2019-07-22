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
        
        //TODO SEND IMAGE OR AUDIO TO AMAZON S3 BUCKET
        
    }
}

extension ApiClient {
    
    enum MediaType {
        case image
        case audio
    }
}
