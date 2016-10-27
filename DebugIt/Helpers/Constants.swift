//
//  Constants.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 25.10.2016.
//  Copyright © 2016 Mood Up. All rights reserved.
//

struct Constants {
    
    static let debuggItUrl = "http://debugg.it"
    
    struct Bitbucket {
        static let authorizeUrl = "https://bitbucket.org/site/oauth2/access_token"
        static let issuesUrl = "https://api.bitbucket.org/1.0/repositories/%@/%@/issues"
    }
    
    struct GitHub {
        static let authorizeUrl = "https://api.github.com/authorizations"
        static let issuesUrl = "https://api.github.com/repos/%@/%@/issues"
        
        static let jsonFormat = "application/vnd.github.v3+json"
        
        static let note = "debugg.it library"
    }
    
    struct Jira {
        static let configurationUrl = "https://%@/rest/api/2/configuration"
        static let issuesUrl = "https://%@/rest/api/2/issue"
    }
}
