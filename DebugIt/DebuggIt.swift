//
//  DebuggIt.swift
//  DebuggIt
//
//  Created by Bartek on 25/10/16.
//  Copyright © 2016 Mood Up. All rights reserved.
//

import UIKit

class DebuggIt {
    
    static let sharedInstance = DebuggIt()
    
    private var currentViewController:UIViewController?
    var apiClient:ApiClientProtocol?
    
    private var report:Report = Report()
    private var configType:ConfigType = ConfigType.bitbucket
    private var isInitialized:Bool = false
    private var shouldPostInitializedEvent:Bool = true
    
    private init() {
    
    }
    
    func initBitbucket(clientId:String, clientSecret:String, repoSlug:String, accountName:String) {
        self.apiClient = BitbucketApiClient(clientId: clientId, clientSecret: clientSecret, repoSlug: repoSlug, accountName: accountName)
        initDebugIt(configType: ConfigType.bitbucket)
    }
    
    func initJira(host:String, projectKey:String, usesHttps:Bool = true) {
        self.apiClient = JiraApiClient(host: host, projectKey: projectKey, usesHttps: usesHttps)
        initDebugIt(configType: ConfigType.jira)
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
            addReportButton()
            
            let modal = LoginModalViewController()
            modal.modalPresentationStyle = .overCurrentContext
            viewController.present(modal, animated: true, completion: nil)
            
            return true
        }
    }
    
    private func addReportButton() {
        let debuggItButton = Bundle.main.loadNibNamed("DebuggItButton", owner: nil, options: nil)?[0] as! UIView
        debuggItButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.currentViewController?.view.addSubview(debuggItButton)
        addConstraints(forView: debuggItButton)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:"showReportDialog:")
        debuggItButton.isUserInteractionEnabled = true
        debuggItButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func addConstraints(forView : UIView) {
        self.currentViewController?.view.addConstraint(NSLayoutConstraint(item: forView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.currentViewController?.view, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0))
        
        self.currentViewController?.view.addConstraint(NSLayoutConstraint(item: forView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.currentViewController?.view, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -forView.frame.width))
    }
    
    func showReportDialog(_ recognizer: UITapGestureRecognizer) {
        print("I am showing byoch")
    }
    
    private func registerShakeDetector() {
        //todo add shake gesture listener
    }
    
}
