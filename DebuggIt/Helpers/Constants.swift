//
//  Constants.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 25.10.2016.
//  Copyright © 2016 Mood Up. All rights reserved.
//

struct Constants {
    
    static let debuggItUrl = "http://debugg.it"
    static let welcomeScreenHasBeenShownKey = "debuggit_first_run"
    
    static let cookiesToRemove = [
        "bb_session",
        "csrftoken",
        "dotcom_user",
        "logged_in",
        "_gh_sess",
        "__Host-user_session_same_site",
        "user_session"
    ]
    
    struct Api {
        private static let baseUrl = Config.sharedInstance.apiBaseUrl()
        static let uploadImageUrl = Api.baseUrl + "/api/v1/upload/image"
        static let uploadAudioUrl = Api.baseUrl + "/api/v1/upload/audio"
        static let eventsUrl = Api.baseUrl + "/api/v2/events"
        static let supportedVersionUrl = Api.baseUrl + "/api/v2/supported_versions/ios/%@"
    }
    
    struct Bitbucket {
        
        //MARL: Priorities
        static let minor = "minor"
        static let major = "major"
        static let critical = "critical"
        
        // MARK: URLs
        
        static let authorizeUrl = "https://bitbucket.org/site/oauth2/authorize"
        static let issuesUrl = "https://api.bitbucket.org/1.0/repositories/%@/%@/issues"
        static let accessTokenUrl = "https://bitbucket.org/site/oauth2/access_token"
        static let callbackUrl = "callback.moodup.com"
        
        // MARK: UserDefault keys
        
        static let accessTokenKey = "bitbucket_access_token"
        static let refreshTokenKey = "bitbucket_refresh_token"
        
        // MARK: Bitbucket consumer keys
        
        static let clientId = "Jz9hKhxwAWgRNcS6m8"
        static let clientSecret = "dzyS7K5mnvcEWFtsS6veUM8RDJxRzwXQ"
    }
    
    struct GitHub {
        
        // MARK: URLs
        
        static let authorizeUrl = "https://github.com/login/oauth/authorize"
        static let issuesUrl = "https://api.github.com/repos/%@/%@/issues"
        static let accessTokenUrl = "https://github.com/login/oauth/access_token"
        
        // MARK: UserDefault keys
        
        static let accessTokenKey = "github_access_token"
        static let twoFactorAuthCodeKey = "github_2fa_code"
        
        // MARK: GitHub app keys
        
        static let clientId = "8aac9632491f7d954664"
        static let clientSecret = "1b7bdf305e08971b3c95c1cfc06fc05eebd59707"
        
        // MARK: API spec
        
        static let jsonFormat = "application/vnd.github.v3+json"
        static let note = "debugg.it library"
    }
    
    struct Jira {
        
        //MARK: Kinds
        static let task = "Task"
        
        // MARK: URLs
        
        static let configurationUrl = "https://%@/rest/api/2/configuration"
        static let issuesUrl = "https://%@/rest/api/2/issue"
        
        // MARK: UserDefault keys
        
        static let usernameKey = "jira_username"
        static let passwordKey = "jira_password"
    }
    
    static let arrowTailWidth: CGFloat = 1.0
    static let arrowHeadWidth: CGFloat = 10.0
    static let arrowHeadLength: CGFloat = 10.0
}
