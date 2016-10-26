//
//  GitHubApiClient.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 25.10.2016.
//  Copyright © 2016 Mood Up. All rights reserved.
//

class GitHubApiClient: ApiClientProtocol {
    
    // MARK: Properties
    
    var repoSlug: String
    var accountName: String
    var accessToken: String?
    var twoFactorAuthCode: String?
    
    // MARK: Initialization
    
    init(repoSlug: String, accountName: String) {
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
