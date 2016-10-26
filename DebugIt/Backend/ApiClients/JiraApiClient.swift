//
//  JiraApiClient.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 25.10.2016.
//  Copyright © 2016 Mood Up. All rights reserved.
//

import Alamofire

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
        
        let headers: HTTPHeaders = [
            "Authorization" : authorizationHeader(username: email, password: password)
        ]
        
        let url = checkUrlProtocol(url: String(format: Constants.Jira.configurationUrl, host))
        
        Alamofire.request(url, method: .post, encoding: URLEncoding.default, headers: headers).responseString { (response) in
            switch response.result {
            case .success(let value):
                if response.isSuccess() {
                    successBlock(value)
                } else {
                    errorBlock(response.responseCode, value)
                }
            case .failure(let error as AFError):
                errorBlock(nil, error.errorDescription)
            default:
                errorBlock(nil, nil)
                
            }
            
        }
        
    }
    
    func addIssue(title: String, content: String, priority: String, kind: String, successBlock: @escaping (String) -> (), errorBlock: @escaping (_ statusCode: Int? , _ body: String?) -> ()) {
        
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
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseString { (response) in
            switch response.result {
            case .success(let value):
                if response.isSuccess() {
                    successBlock(value)
                } else {
                    errorBlock(response.responseCode, value)
                }
            case .failure(let error as AFError):
                errorBlock(nil, error.errorDescription)
            default:
                errorBlock(nil, nil)
                
            }
            
        }

        
    }
    
    func refreshToken(token: String, successBlock: @escaping (String) -> (), errorBlock: @escaping (_ statusCode: Int? , _ body: String?) -> ()) {
        // do nothing
    }
    
    private func checkUrlProtocol(url: String) -> String {
        if !usesHttps {
            return url.replaceFirst(replace: "s", with: "")
        }
        return url
    }
}
