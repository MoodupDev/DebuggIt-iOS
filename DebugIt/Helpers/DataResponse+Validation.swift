//
//  DataResponse+Validation.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 26.10.2016.
//  Copyright © 2016 Mood Up. All rights reserved.
//

import Alamofire

extension DataResponse {
    
    var responseCode: Int? {
        get {
            return self.response?.statusCode
        }
    }
    
    
    func isSuccess() -> Bool {
        if let code = responseCode {
            return 200...299 ~= code
        }
        return false
    }
}
