
//  GitHubApiClient.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 25.10.2016.
//  Copyright © 2016 Mood Up. All rights reserved.
//

import Alamofire
import SwiftyJSON

class GitHubApiClient: ApiClientProtocol {
    
    // MARK: Properties
    
    var repoSlug: String
    var accountName: String
    var accessToken: String?
    
    let loginUrl: String = "\(Constants.GitHub.authorizeUrl)?client_id=\(Constants.GitHub.clientId)&scope=repo"
    var hasToken: Bool {
        get {
            return accessToken != nil
        }
    }
    
    // MARK: Initialization
    
    init(repoSlug: String, accountName: String) {
        self.repoSlug = repoSlug.lowercased()
        self.accountName = accountName
        
        loadTokens()
    }
    
    // MARK: ApiClient
    
    func addIssue(title: String, content: String, priority: String, kind: String, successBlock: (() -> ())?, errorBlock: ((_ statusCode: Int? , _ body: String?) -> ())?) {
        
        let params : Parameters = [
            "title": title,
            "body": content,
            "labels": [
                kind
            ]
        ]
        
        let headers: HTTPHeaders = [
            "Accept" : Constants.GitHub.jsonFormat,
            "Authorization" : authorizationHeader(prefix: "token", token: accessToken ?? "")
        ]
        
        Alamofire.request(String(format: Constants.GitHub.issuesUrl, accountName, repoSlug), method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString { (response) in
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
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        let params : Parameters = [
            "client_id": Constants.GitHub.clientId,
            "client_secret": Constants.GitHub.clientSecret,
            "code": code
        ]
        
        Alamofire.request(Constants.GitHub.accessTokenUrl, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseString { (response) in
            switch response.result {
            case .success(let value):
                if response.isSuccess() {
                    self.storeTokens(from: value)
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
    
    private func storeTokens(from jsonString: String) {
        let json = JSON.init(parseJSON: jsonString)
        self.accessToken = json["access_token"].stringValue
        
        let manager = TokenManager.sharedManager
        manager.put(key: Constants.GitHub.accessTokenKey, value: accessToken)
    }
    
    func loadTokens() {
        self.accessToken = TokenManager.sharedManager.get(key: Constants.GitHub.accessTokenKey)
    }
    
    func clearTokens() {
        accessToken = nil
        TokenManager.sharedManager.remove(Constants.GitHub.accessTokenKey)
    }
}
