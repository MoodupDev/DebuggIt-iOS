//
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
    var twoFactorAuthCode: String?
    
    // MARK: Initialization
    
    init(repoSlug: String, accountName: String) {
        self.repoSlug = repoSlug.lowercased()
        self.accountName = accountName
        
        loadTokens()
    }
    
    // MARK: ApiClient
    
    func login(email: String, password: String, successBlock: @escaping () -> (), errorBlock: @escaping (_ statusCode: Int? , _ body: String?) -> ()) {
        
        let params: Parameters = [
            "scopes": [
                "repo"
            ],
            "note": "\(Constants.GitHub.note) at \(NSDate())",
            "note_url" : Constants.debuggItUrl
        ]
        
        var headers: HTTPHeaders = [
            "Accept" : Constants.GitHub.jsonFormat,
            "Authorization" : authorizationHeader(username: email, password: password)
        ]
        
        if let twoFactorCode = twoFactorAuthCode {
            headers["X-Github-OTP"] = twoFactorCode
            
        }
        
        Alamofire.request(Constants.GitHub.authorizeUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString { (response) in
            switch response.result {
            case .success(let value):
                if response.isSuccess() {
                    self.storeTokens(from: value)
                    successBlock()
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
    
    func addIssue(title: String, content: String, priority: String, kind: String, successBlock: @escaping () -> (), errorBlock: @escaping (_ statusCode: Int? , _ body: String?) -> ()) {
        
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
                    successBlock()
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
    
    func hasToken() -> Bool {
        return accessToken != nil
    }
    
    func clearTokens() {
        accessToken = nil
    }
    
    func refreshAccessToken(successBlock: @escaping () -> (), errorBlock: @escaping (_ statusCode: Int? , _ body: String?) -> ()) {
        // do nothing
    }
    
    private func storeTokens(from jsonString: String) {
        let json = JSON.parse(jsonString)
        self.accessToken = json["token"].stringValue
        
        let defaults = UserDefaults.standard
        defaults.set(accessToken, forKey: Constants.GitHub.accessTokenKey)
        defaults.set(twoFactorAuthCode, forKey: Constants.GitHub.twoFactorAuthCodeKey)
        defaults.synchronize()
    }
    
    private func loadTokens() {
        let defaults = UserDefaults.standard
        if let accessToken = defaults.string(forKey: Constants.GitHub.accessTokenKey) {
            self.accessToken = accessToken
        }
        if let accessToken = defaults.string(forKey: Constants.GitHub.accessTokenKey) {
            self.accessToken = accessToken
        }
    }
}
