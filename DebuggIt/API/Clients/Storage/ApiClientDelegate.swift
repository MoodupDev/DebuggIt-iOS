//
//  ApiClientDelegate.swift
//  DebuggIt
//
//  Created by Piotr Gomoła on 25/07/2019.
//  Copyright © 2019 Mood Up. All rights reserved.
//

import Foundation


public class ApiClientDelegate: NSObject, UploadDelegate {
    
    public var successClousure: (String) -> ()
    public var errorClousure: (Int?, String?) -> ()
    
    init(onSuccess: @escaping (String) -> (),
         onError: @escaping (Int?, String?) -> ()) {
        self.successClousure = onSuccess
        self.errorClousure = onError
    }
    
    func onSuccess(fileURL: String) {
        successClousure(fileURL)
    }
    
    func onError(code: Int?, message: String?) {
        errorClousure(code, message)
    }
}
