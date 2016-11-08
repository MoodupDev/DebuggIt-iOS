//
//  Constants.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 25.10.2016.
//  Copyright © 2016 Mood Up. All rights reserved.
//

struct Constants {
    
    static let debuggItUrl = "http://debugg.it"
    
    struct Api {
        private static let baseUrl = "https://debuggit-api-staging.herokuapp.com"
        static let uploadImageUrl = Api.baseUrl + "/api/v1/upload/image"
        static let uploadAudioUrl = Api.baseUrl + "/api/v1/upload/audio"
        static let eventsUrl = Api.baseUrl + "/api/v1/events"
    }
    
    struct Bitbucket {
        
        //MARL: Priorities
        static let minor = "minor"
        static let major = "major"
        static let critical = "critical"
        
        // MARK: URLs
        
        static let authorizeUrl = "https://bitbucket.org/site/oauth2/access_token"
        static let issuesUrl = "https://api.bitbucket.org/1.0/repositories/%@/%@/issues"
        
        // MARK: UserDefault keys
        
        static let accessTokenKey = "bitbucket_access_token"
        static let refreshTokenKey = "bitbucket_refresh_token"
    }
    
    struct GitHub {
        
        // MARK: URLs
        
        static let authorizeUrl = "https://api.github.com/authorizations"
        static let issuesUrl = "https://api.github.com/repos/%@/%@/issues"
        
        // MARK: UserDefault keys
        
        static let accessTokenKey = "github_access_token"
        static let twoFactorAuthCodeKey = "github_2fa_code"
        
        // MARK: API spec
        
        static let jsonFormat = "application/vnd.github.v3+json"
        static let note = "debugg.it library"
    }
    
    struct Jira {
        
        // MARK: URLs
        
        static let configurationUrl = "https://%@/rest/api/2/configuration"
        static let issuesUrl = "https://%@/rest/api/2/issue"
        
        // MARK: UserDefault keys
        
        static let usernameKey = "jira_username"
        static let passwordKey = "jira_password"
    }
}
