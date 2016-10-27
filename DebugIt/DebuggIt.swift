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
    let debuggItButton = DebuggItButton.instantiateFromNib()
    
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
            
            return true
        }
    }
    
    private func addReportButton() {
        debuggItButton.clipsToBounds = true
        debuggItButton.translatesAutoresizingMaskIntoConstraints = false
        debuggItButton.isUserInteractionEnabled = true
        
        self.currentViewController?.view.addSubview(debuggItButton)
        addConstraints(forView: debuggItButton)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.showReportDialog(_:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action:#selector(self.moveButton(_:)))
        
        debuggItButton.addGestureRecognizer(tapGestureRecognizer)
        debuggItButton.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func addConstraints(forView : UIView) {
        self.currentViewController?.view.addConstraint(NSLayoutConstraint(item: forView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.currentViewController?.view, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0))
        
        self.currentViewController?.view.addConstraint(NSLayoutConstraint(item: forView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.currentViewController?.view, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0.0))
    }
    
    @objc func showReportDialog(_ recognizer: UITapGestureRecognizer) {
        let modal = LoginModalViewController()
        modal.modalPresentationStyle = .overCurrentContext
        self.currentViewController?.present(modal, animated: true, completion: nil)
    }
    
    @objc func moveButton(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
            if let view = recognizer.view {
                let translation = recognizer.translation(in: view)
                if(translation.y < 0.0 && view.center.y > (view.frame.height / 2)
                    || translation.y >= 0.0 && view.center.y < ((self.currentViewController?.view.frame.maxY)! - (view.frame.height/2))) {
                    view.center = CGPoint(x: view.center.x, y: view.center.y + translation.y)
                    recognizer.setTranslation(CGPoint.zero, in: view)
                }
            }
        }
    }
    
    private func registerShakeDetector() {
        //todo add shake gesture listener
    }
    
}
