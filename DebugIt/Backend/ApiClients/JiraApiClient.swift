//
//  JiraApiClient.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 25.10.2016.
//  Copyright © 2016 Mood Up. All rights reserved.
//

class JiraApiClient: ApiClientProtocol {
    
    // MARK: Properties
    
    var host: String
    var projectKey: String
    var usesHttps: Bool
    var username: String?
    var password: String?
    
    // MARK: Initialization
    
    init(host: String, projectKey: String, usesHttps: Bool) {
        self.host = host
        self.projectKey = projectKey
        self.usesHttps = usesHttps
    }
    
    // MARK: ApiClient
    
    func login(email: String, password: String, successBlock: @escaping (String) -> (), errorBlock: @escaping (_ statusCode: Int? , _ body: String?) -> ()) {
        
    }
    
    func addIssue(title: String, content: String, priority: String, kind: String, successBlock: @escaping (String) -> (), errorBlock: @escaping (_ statusCode: Int? , _ body: String?) -> ()) {
        
    }
    
    func refreshToken(token: String, successBlock: @escaping (String) -> (), errorBlock: @escaping (_ statusCode: Int? , _ body: String?) -> ()) {
        
    }
}
