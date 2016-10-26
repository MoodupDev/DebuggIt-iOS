//
//  DebuggIt.swift
//  DebuggIt
//
//  Created by Bartek on 25/10/16.
//  Copyright © 2016 Mood Up. All rights reserved.
//

import UIKit

extension Bundle {
    static func loadView<T>(fromNib name:String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }
        
        fatalError("Waddup")
    }
}


class DebuggIt {
    
    static let sharedInstance = DebuggIt()
    
    private var currentViewController:UIViewController?
    private var apiClient:ApiClientProtocol?
    
    private var report:Report = Report()
    private var configType:ConfigType = ConfigType.bitbucket
    private var isInitialized:Bool = false
    private var shouldPostInitializedEvent:Bool = true
    
    init() {
    
    }
    
    func initBitbucket(clientId:String, clientSecret:String, repoSlug:String, accountName:String) {
        self.apiClient = BitbucketApiClient(clientId: clientId, clientSecret: clientSecret, repoSlug: repoSlug, accountName: accountName)
        initDebugIt(configType: ConfigType.bitbucket)
    }
    
    func initJira(host:String, projectKey:String, usesHttps:Bool) {
        self.apiClient = JiraApiClient(host: host, projectKey: projectKey, usesHttps: usesHttps)
        initDebugIt(configType: ConfigType.jira)
    }
    
    func initJira(host:String, projectKey:String) {
        initJira(host: host, projectKey: projectKey, usesHttps: true)
    }
    
    func initGithub(repoSlug:String, accountName:String) {
        self.apiClient = GitHubApiClient(repoSlug: repoSlug, accountName: accountName)
        initDebugIt(configType: ConfigType.github)
    }
    
    private func initDebugIt(configType:ConfigType) {
        self.configType = configType
        self.isInitialized = true
    }
    
    func attach(viewController:UIViewController) throws -> Bool {
        if(!isInitialized) {
            throw DebuggItError.notInitialized(message: "Call init before attach")
        } else {
            if(shouldPostInitializedEvent) {
                //todo post event that initialized
                shouldPostInitializedEvent = false
            }
            //todo add version checking
            
            self.currentViewController = viewController
            registerShakeDetector()
            
            
            return true
        }
    }
    
    private func addReportButton() {
        let debuggItButton = Bundle.loadView(fromNib: "DebuggItButton", withType: DebuggItButton.self)
        self.currentViewController?.view.addSubview(debuggItButton)
    }
    
    private func registerShakeDetector() {
        //todo add shake gesture listener
    }
    
}
