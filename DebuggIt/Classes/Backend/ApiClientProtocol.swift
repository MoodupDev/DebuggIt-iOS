//
//  ApiService.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 25.10.2016.
//  Copyright © 2016 Mood Up. All rights reserved.
//

import KeychainAccess

protocol ApiClientProtocol {
    
    // MARK: - Properties
    
    var loginUrl: String { get }
    var hasToken: Bool { get }
    var keychain: Keychain { get }
    
    // MARK: - Methods
    
    func addIssue(title: String,
                  content: String,
                  priority: String,
                  kind: String,
                  successBlock: (() -> ())?,
                  errorBlock: ((_ statusCode: Int? , _ body: String?) -> ())?
    )
    
    func refreshAccessToken(successBlock:  (() -> ())?,
                      errorBlock: ((_ statusCode: Int? , _ body: String?) -> ())?
    )
    
    func clearTokens()
    
    func exchangeAuthCodeForToken(_ code: String,
                              successBlock:  (() -> ())?,
                              errorBlock: ((_ statusCode: Int? , _ body: String?) -> ())?
    )
    
    func login(email: String,
               password: String,
               successBlock:  (() -> ())?,
               errorBlock: ((_ statusCode: Int? , _ body: String?) -> ())?
    )
    
}

// MARK: - Defaults

extension ApiClientProtocol {
    func login(email: String,
               password: String,
               successBlock:  (() -> ())?,
               errorBlock: ((_ statusCode: Int? , _ body: String?) -> ())?
        ) {
        
    }
    
    var keychain: Keychain {
        return Keychain(service: "com.moodup.debuggit")
    }
}
