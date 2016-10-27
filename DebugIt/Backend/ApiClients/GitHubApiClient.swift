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
    }
    
    // MARK: ApiClient
    
    func login(email: String, password: String, successBlock: @escaping (String) -> (), errorBlock: @escaping (_ statusCode: Int? , _ body: String?) -> ()) {
        
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
                    self.storeToken(from: value)
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
        
        Alamofire.request(Constants.Bitbucket.authorizeUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString { (response) in
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
    
    private func storeToken(from jsonString: String) {
        let json = JSON.parse(jsonString)
        self.accessToken = json["token"].stringValue
    }
}
