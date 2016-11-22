//
//  BitbucketApiClient.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 25.10.2016.
//  Copyright © 2016 Mood Up. All rights reserved.
//

import Alamofire
import SwiftyJSON

class BitbucketApiClient: ApiClientProtocol {
    
    // MARK: Properties
    
    var loginUrl: String = "\(Constants.Bitbucket.authorizeUrl)?client_id=\(Constants.Bitbucket.clientId)&response_type=code"
    
    var clientId: String
    var clientSecret: String
    var repoSlug: String
    var accountName: String
    var accessToken: String?
    var refreshToken: String?
    
    // MARK: Initialization
    
    init(clientId: String, clientSecret: String, repoSlug: String, accountName: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.repoSlug = repoSlug.lowercased()
        self.accountName = accountName
        
        loadTokens()
    }
    
    // MARK: ApiClient
    
    func addIssue(title: String, content: String, priority: String, kind: String, successBlock: @escaping () -> (), errorBlock: @escaping (_ statusCode: Int? , _ body: String?) -> ()) {
        
        let params: Parameters = [
            "title": title,
            "content": content,
            "priority": priority.lowercased(),
            "kind": kind.lowercased()
        ]
        
        let headers : HTTPHeaders = [
            "Authorization": authorizationHeader(token: accessToken ?? "")
        ]
        
        Alamofire.request(String(format: Constants.Bitbucket.issuesUrl, accountName, repoSlug), method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseString { (response) in
            switch response.result {
            case .success(let value):
                if response.isSuccess() {
                    successBlock()
                } else {
                    if response.responseCode == 401 {
                        self.refreshAccessToken(successBlock: {
                            self.addIssue(title: title, content: content, priority: priority, kind: kind, successBlock: successBlock, errorBlock: errorBlock)
                        }, errorBlock: { (code, message) in
                            errorBlock(code, message)
                        })
                    } else {
                        errorBlock(response.responseCode, value)
                    }
                }
            case .failure(let error as AFError):
                errorBlock(nil, error.errorDescription)
            default:
                errorBlock(nil, nil)
                
            }
        }
        
    }
    
    func refreshAccessToken(successBlock: @escaping () -> (), errorBlock: @escaping (_ statusCode: Int?, _ body: String?) -> ()) {
        
        let params: Parameters = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken ?? ""
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": authorizationHeader(username: clientId, password: clientSecret)
        ]
        
        Alamofire.request(Constants.Bitbucket.authorizeUrl, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseString { (response) in
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
    
    func hasToken() -> Bool {
        return accessToken != nil
    }
    
    func clearTokens() {
        accessToken = nil
        refreshToken = nil
    }
    
    internal func exchangeAuthCodeForToken(_ code: String, successBlock: @escaping () -> (), errorBlock: @escaping (Int?, String?) -> ()) {
        
        let headers: HTTPHeaders = [
            "Authorization": authorizationHeader(username: clientId, password: clientSecret)
        ]
        
        let params: Parameters = [
            "grant_type": "authorization_code",
            "code": code
        ]
        
        Alamofire.request(Constants.Bitbucket.accessTokenUrl, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseString { (response) in
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
    
    private func storeTokens(from jsonString: String) {
        let json = JSON.parse(jsonString)
        accessToken = json["access_token"].stringValue
        refreshToken = json["refresh_token"].stringValue
        
        let defaults = UserDefaults.standard
        defaults.set(self.accessToken, forKey: Constants.Bitbucket.accessTokenKey)
        defaults.set(self.refreshToken, forKey: Constants.Bitbucket.refreshTokenKey)
        defaults.synchronize()
    }
    
    private func loadTokens() {
        let defaults = UserDefaults.standard
        if let accessToken = defaults.string(forKey: Constants.Bitbucket.accessTokenKey) {
            self.accessToken = accessToken
        }
        if let refreshToken = defaults.string(forKey: Constants.Bitbucket.refreshTokenKey) {
            self.refreshToken = refreshToken
        }
    }
}
