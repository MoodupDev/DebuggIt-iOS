//
//  ApiClientDelegate.swift
//  DebuggIt
//
//  Created by Piotr Gomoła on 25/07/2019.
//  Copyright © 2019 Mood Up. All rights reserved.
//

import Foundation


final public class ApiClientDelegate: NSObject, UploadDelegate {
    
    public var uploadSuccessClousure: (String) -> ()
    public var errorClousure: (Int?, String?) -> ()
    
    init(onUploadSuccess: @escaping (String) -> (),
         onError: @escaping (Int?, String?) -> ()) {
        self.uploadSuccessClousure = onUploadSuccess
        self.errorClousure = onError
    }
    
    func onUploadSuccess(fileURL: String) {
        uploadSuccessClousure(fileURL)
    }
    
    func onError(code: Int?, message: String?) {
        errorClousure(code, message)
    }
}
