//
//  JiraApiClient.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 25.10.2016.
//  Copyright © 2016 Mood Up. All rights reserved.
//

import Alamofire
import SwiftyJSON

class JiraApiClient: ApiClientProtocol {

    // MARK: Properties
    
    internal var loginUrl: String = ""
    var hasToken: Bool {
        get {
            return username != nil && password != nil
        }
    }
    
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
        
        loadTokens()
    }
    
    // MARK: ApiClient
    
    func addIssue(title: String, content: String, priority: String, kind: String, successBlock: (() -> ())?, errorBlock: ((_ statusCode: Int? , _ body: String?) -> ())?) {
        
        let params: Parameters = [
            "fields" : [
                "issuetype": [
                    "name": kind
                ],
                "summary": title,
                "project": [
                    "key": projectKey
                ],
                "description": content,
                "priority": [
                    "name": priority
                ]
            ]
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": authorizationHeader(username: username ?? "", password: password ?? "")
        ]
        
        let url = checkUrlProtocol(url: String(format: Constants.Jira.issuesUrl, host))
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString { (response) in
            switch response.result {
            case .success(let value):
                if response.isSuccess() {
                    successBlock?()
                } else {
                    errorBlock?(response.responseCode, value)
                }
            case .failure(let error as AFError):
                errorBlock?(nil, error.errorDescription)
            default:
                errorBlock?(nil, nil)
                
            }
            
        }

        
    }
    
    func refreshAccessToken(successBlock: (() -> ())?, errorBlock: ((_ statusCode: Int? , _ body: String?) -> ())?) {
        // do nothing
    }
    
    internal func exchangeAuthCodeForToken(_ code: String, successBlock: (() -> ())?, errorBlock: ((_ statusCode: Int? , _ body: String?) -> ())?) {
        
    }
    
    func login(email: String, password: String, successBlock: (() -> ())?, errorBlock: ((_ statusCode: Int? , _ body: String?) -> ())?) {
        
        let headers: HTTPHeaders = [
            "Authorization" : authorizationHeader(username: email, password: password)
        ]
        
        let url = checkUrlProtocol(url: String(format: Constants.Jira.configurationUrl, host))
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: headers).responseString { (response) in
            switch response.result {
            case .success(let value):
                if response.isSuccess() {
                    self.storeUserCredentials(email: email, password: password)
                    successBlock?()
                } else {
                    errorBlock?(response.responseCode, value)
                }
            case .failure(let error as AFError):
                errorBlock?(nil, error.errorDescription)
            default:
                errorBlock?(nil, nil)
                
            }
            
        }
        
    }
    
    private func checkUrlProtocol(url: String) -> String {
        if !usesHttps {
            return url.replaceFirst(replace: "s", with: "")
        }
        return url
    }
    
    private func storeUserCredentials(email: String, password: String) {
        self.username = email
        self.password = password
        
        let manager = TokenManager.sharedManager
        manager.put(key: Constants.Jira.usernameKey, value: self.username)
        manager.put(key: Constants.Jira.passwordKey, value: self.password)
    }
    
    func loadTokens() {
        let manager = TokenManager.sharedManager
        self.username = manager.get(key: Constants.Jira.usernameKey)
        self.password = manager.get(key: Constants.Jira.passwordKey)
    }
    
    func clearTokens() {
        username = nil
        password = nil
        
        TokenManager.sharedManager.remove(Constants.Jira.usernameKey, Constants.Jira.passwordKey)
    }
}
