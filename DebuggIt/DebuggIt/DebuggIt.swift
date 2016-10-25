//
//  DebuggIt.swift
//  DebuggIt
//
//  Created by Bartek on 25/10/16.
//  Copyright © 2016 Mood Up. All rights reserved.
//

import UIKit

class DebuggIt: NSObject {

    static let sharedInstance = DebuggIt()
    
    private var currentViewController:UIViewController?
    private var isInitialized:Bool = false
    private var report:Report?
    
    override init() {
        super.init()
    }
    
    func initBitbucket(clientId:String, clientSecret:String, repoSlug:String, accountName:String) {
        //todo add bitbucket initialization
    }
    
    func initJira(host:String, projectKey:String, usesHttps:Bool) {
        //todo add jira initialization
    }
    
    func initJira(host:String, projectKey:String) {
        initJira(host: host, projectKey: projectKey, usesHttps: true)
    }
    
    func initGithub(repoSlug:String, accountName:String) {
        
    }
    
}
