//
//  BitbucketApiClient.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 25.10.2016.
//  Copyright © 2016 Mood Up. All rights reserved.
//

import Alamofire
import SwiftyJSON

final class BitbucketApiClient: ApiClientProtocol {
    
    // MARK: Properties
    
    let loginUrl: String = "\(Constants.Bitbucket.authorizeUrl)?client_id=\(Constants.Bitbucket.clientId)&response_type=code"
    
    var repoSlug: String
    var accountName: String
    var accessToken: String?
    var refreshToken: String?
    
    var hasToken: Bool {
        get {
            return self.accessToken != nil
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
        
        let params: Parameters = [
            "title": title,
            "content": [
                "raw": content,
                "markup": "markdown"
            ],
            "priority": priority.lowercased(),
            "kind": kind.lowercased()
        ]
        
        let headers : HTTPHeaders = [
            "Authorization": authorizationHeader(token: accessToken ?? "")
        ]
        
        AF.request(String(format: Constants.Bitbucket.issuesUrl, accountName, repoSlug), method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString { (response) in
            switch response.result {
            case .success(let value):
                if response.isSuccess() {
                    successBlock?()
                } else {
                    if response.responseCode == 401 {
                        self.refreshAccessToken(successBlock: {
                            self.addIssue(title: title, content: content, priority: priority, kind: kind, successBlock: successBlock, errorBlock: errorBlock)
                        }, errorBlock: { (code, message) in
                            errorBlock?(code, message)
                        })
                    } else {
                        errorBlock?(response.responseCode, value)
                    }
                }
            case .failure(let error as AFError):
                errorBlock?(nil, error.errorDescription)
            default:
                errorBlock?(nil, nil)
                
            }
        }
    }
    
    func refreshAccessToken(successBlock: (() -> ())?, errorBlock: ((_ statusCode: Int? , _ body: String?) -> ())?) {
        
        let params: Parameters = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken ?? ""
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": authorizationHeader(
                                username: Constants.Bitbucket.clientId,
                                password: Constants.Bitbucket.clientSecret
                            )
        ]
        
        AF.request(Constants.Bitbucket.accessTokenUrl, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseString { (response) in
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
    
    internal func exchangeAuthCodeForToken(_ code: String, successBlock: (() -> ())?, errorBlock: ((_ statusCode: Int? , _ body: String?) -> ())?) {
        
        let headers: HTTPHeaders = [
            "Authorization": authorizationHeader(
                                username: Constants.Bitbucket.clientId,
                                password: Constants.Bitbucket.clientSecret
                            )
        ]
        
        let params: Parameters = [
            "grant_type": "authorization_code",
            "code": code
        ]
        
        AF.request(Constants.Bitbucket.accessTokenUrl, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseString { (response) in
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
        self.refreshToken = json["refresh_token"].stringValue
        
        let manager = TokenManager.sharedManager
        manager.put(key: Constants.Bitbucket.accessTokenKey, value: accessToken)
        manager.put(key: Constants.Bitbucket.refreshTokenKey, value: refreshToken)
    }
    
    func loadTokens() {
        let manager = TokenManager.sharedManager
        self.accessToken = manager.get(key: Constants.Bitbucket.accessTokenKey)
        self.refreshToken = manager.get(key: Constants.Bitbucket.refreshTokenKey)
    }
    
    func clearTokens() {
        self.accessToken = nil
        self.refreshToken = nil
        
        TokenManager.sharedManager.remove([Constants.Bitbucket.accessTokenKey, Constants.Bitbucket.refreshTokenKey])
    }
}
