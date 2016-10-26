//
//  ApiService.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 25.10.2016.
//  Copyright © 2016 Mood Up. All rights reserved.
//


protocol ApiClientProtocol {
    func login(email: String,
               password: String,
               successBlock: (_ response: String) -> (),
               errorBlock: (_ error: Error?) -> ()
    )
    
    func addIssue(title: String,
                  content: String,
                  priority: String,
                  kind: String,
                  successBlock: (_ response: String) -> (),
                  errorBlock: (_ error: Error?) -> ()
    )
    
    func refreshToken(token: String,
                      successBlock: (_ response: String) -> (),
                      errorBlock: (_ error: Error?) -> ()
    )
    
}
