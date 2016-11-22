//
//  ApiService.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 25.10.2016.
//  Copyright © 2016 Mood Up. All rights reserved.
//

protocol ApiClientProtocol {
    
    var loginUrl: String { get }
    
    func addIssue(title: String,
                  content: String,
                  priority: String,
                  kind: String,
                  successBlock: @escaping () -> (),
                  errorBlock: @escaping (_ statusCode: Int? , _ body: String?) -> ()
    )
    
    func refreshAccessToken(successBlock: @escaping () -> (),
                      errorBlock: @escaping (_ statusCode: Int? , _ body: String?) -> ()
    )
    
    func hasToken() -> Bool
    
    func clearTokens()
    
    func exchangeAuthCodeForToken(_ code: String,
                              successBlock: @escaping () -> (),
                              errorBlock: @escaping (_ statusCode: Int? , _ body: String?) -> ())
}
