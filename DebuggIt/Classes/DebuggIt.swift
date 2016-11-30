//
//  DebuggIt.swift
//  DebuggIt
//
//  Created by Bartek on 25/10/16.
//  Copyright © 2016 Mood Up. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@objc
public class DebuggIt: NSObject {
    
    @objc public static let sharedInstance = DebuggIt()
    let debuggItButton = DebuggItButton.instantiateFromNib()
    
    private var currentViewController:UIViewController?
    var apiClient:ApiClientProtocol?
    var configType:ConfigType = .bitbucket
    
    var report:Report = Report()
    private var isInitialized:Bool = false
    private var shouldPostInitializedEvent:Bool = true
    
    @objc public var recordingEnabled = false
    
    private override init() {
        
    }
    
    @objc public func initBitbucket(repoSlug: String, accountName: String) {
        apiClient = BitbucketApiClient(repoSlug: repoSlug, accountName: accountName)
        initDebugIt(configType: .bitbucket)
    }
    
    @objc public func initJira(host: String, projectKey: String, usesHttps: Bool = true) {
        apiClient = JiraApiClient(host: host, projectKey: projectKey, usesHttps: usesHttps)
        initDebugIt(configType: .jira)
    }
    
    @objc public func initGithub(repoSlug: String, accountName: String) {
        apiClient = GitHubApiClient(repoSlug: repoSlug, accountName: accountName)
        initDebugIt(configType: .github)
    }
    
    func initDebugIt(configType:ConfigType) {
        self.configType = configType
        report.configType = configType
        isInitialized = true
        ApiClient.postEvent(.initialized)
    }
    
    @objc public func attach(viewController: UIViewController) throws -> Void {
        if(!isInitialized) {
            throw DebuggItError.notInitialized(message: "Call init before attach")
        } else {
            if(shouldPostInitializedEvent) {
                ApiClient.postEvent(.initialized)
                shouldPostInitializedEvent = false
            }
            //todo add version checking
            
            currentViewController = viewController
            
            registerShakeDetector()
            addReportButton()
        }
    }
    
    func sendReport(successBlock: @escaping () -> (), errorBlock: @escaping (_ statusCode: Int?,_ message: String?) -> ()) {
        let contentString =  report.stepsToReproduce + "\n" + report.expectedBehavior + "\n" + report.actualBehavior + "\n"
        
        apiClient?.addIssue(
            title: report.title,
            content: contentString + report.screenshotsUrls.reduce("", {$0 + "\n" + $1}),
            priority: Utils.convert(fromPriority: report.priority),
            kind: Utils.convert(fromKind: report.kind),
            successBlock: successBlock,
            errorBlock: errorBlock)
    }
    
    private func addReportButton() {
        debuggItButton.clipsToBounds = true
        debuggItButton.translatesAutoresizingMaskIntoConstraints = false
        debuggItButton.isUserInteractionEnabled = true
        
        debuggItButton.layoutIfNeeded()
        
        debuggItButton.imageView.roundCorners(corners: [.topRight, .bottomRight], radius: 5)
        debuggItButton.edge.roundCorners(corners: [.bottomLeft, .topLeft], radius: 5)
        
        currentViewController?.view.addSubview(debuggItButton)
        addConstraints(forView: debuggItButton)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(showReportDialog(_:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action:#selector(moveButton(_:)))
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(handleLongPress(_:)))
        
        debuggItButton.addGestureRecognizer(tapGestureRecognizer)
        debuggItButton.addGestureRecognizer(panGestureRecognizer)
        debuggItButton.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    
    private func addConstraints(forView : UIView) {
        currentViewController?.view.addConstraint(NSLayoutConstraint(item: forView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: currentViewController?.view, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0))
        
        currentViewController?.view.addConstraint(NSLayoutConstraint(item: forView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: currentViewController?.view, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0.0))
    }
    
    private func logout() {
        apiClient?.clearTokens()
    }
    
    @objc func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
        let alertController = UIAlertController(title: "Logout", message: "Do you want to logout?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction!) in
            self.logout()
            alertController.dismiss(animated: false, completion: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction!) in
            alertController.dismiss(animated: false, completion: nil)
        }))
        
        currentViewController?.present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func showReportDialog(_ recognizer: UITapGestureRecognizer) {
        debuggItButton.isHidden = true
        takeScreenshot()
        debuggItButton.isHidden = false
        if (apiClient?.hasToken)! {
            showModal(viewController: Initializer.viewController(EditScreenshotModalViewController.self))
        } else {
            showLoginWebView()
        }
    }
    
    func showLoginWebView() {
        IQKeyboardManager.sharedManager().enable = true
        
        let loginViewController = Initializer.viewController(WebViewViewController.self)
        loginViewController.url = apiClient?.loginUrl
        
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(DebuggIt.cancelLogin))
        navigationController.navigationBar.topItem?.title = "Sign in"
        
        showModal(viewController: navigationController)
    }
    
    @objc func cancelLogin() {
        currentViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func moveButton(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
            if let view = recognizer.view {
                let translation = recognizer.translation(in: view)
                if(translation.y < 0.0 && view.center.y > (view.frame.height / 2)
                    || translation.y >= 0.0 && view.center.y < ((currentViewController?.view.frame.maxY)! - (view.frame.height/2))) {
                    view.center = CGPoint(x: view.center.x, y: view.center.y + translation.y)
                    recognizer.setTranslation(CGPoint.zero, in: view)
                }
            }
        }
    }
    
    private func takeScreenshot() {
        let window:UIWindow! = UIApplication.shared.keyWindow
        report.screenshots.append(window.capture())
    }
    
    private func showModal(viewController: UIViewController) {
        viewController.modalPresentationStyle = .overCurrentContext
        currentViewController?.present(viewController, animated: true, completion: nil)
    }
    
    
    
    private func registerShakeDetector() {
        //todo add shake gesture listener
    }
    
}
