//
//  BitbucketApiClient.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 25.10.2016.
//  Copyright © 2016 Mood Up. All rights reserved.
//

import Alamofire

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
        self.repoSlug = repoSlug.lowercased()
        self.accountName = accountName
    }
    
    // MARK: ApiClient
    
    func login(
        email: String,
        password: String,
        successBlock: @escaping (String) -> (),
        errorBlock: @escaping (_ statusCode: Int? , _ body: String?) -> ()) {
        
        let params: Parameters = [
            "grant_type" : "password",
            "username" : email,
            "password" : password
        ]
        
        let headers = [
            "Authorization": authorizationHeader(username: clientId, password: clientSecret)
        ]
        
        Alamofire.request(Constants.Bitbucket.authorizeUrl, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseString { (response) in
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
            "title": title,
            "content": content,
            "priority": priority,
            "kind": kind
        ]
        
        let headers : HTTPHeaders = [
            "Authorization": authorizationHeader(token: accessToken ?? "")
        ]
        
        Alamofire.request(String(format: Constants.Bitbucket.issuesUrl, accountName, repoSlug), method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseString { (response) in
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
        
        let params: Parameters = [
            "grant_type": "refresh_token",
            "refresh_token": token
        ]
        
        var headers : [String: String] = [:]
        
        if let accessToken = accessToken {
            headers["Authorization"] = authorizationHeader(token: accessToken)
        }
        
        Alamofire.request(Constants.Bitbucket.issuesUrl, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseString { (response) in
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
}
