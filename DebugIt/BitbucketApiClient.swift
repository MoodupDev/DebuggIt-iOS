//
//  BitbucketApiClient.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 25.10.2016.
//  Copyright © 2016 Mood Up. All rights reserved.
//

class BitbucketApiClient: ApiClientProtocol {
    
    // MARK: Properties
    
    var clientId: String
    var clientSecret: String
    var repoSlug: String
    var accountName: String
    var accessToken: String?
    
    // MARK: Initialization
    
    init(clientId: String, clientSecret: String, repoSlug: String, accountName: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.repoSlug = repoSlug
        self.accountName = accountName
    }
    
    // MARK: ApiClient
    
    func login(email: String, password: String, successBlock: (String) -> (), errorBlock: (Error?) -> ()) {
        
    }
    
    func addIssue(title: String, content: String, priority: String, kind: String, successBlock: (String) -> (), errorBlock: (Error?) -> ()) {
        
    }
    
    func refreshToken(token: String, successBlock: (String) -> (), errorBlock: (Error?) -> ()) {
        
    }
}
