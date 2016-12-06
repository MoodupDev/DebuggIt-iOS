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
    var applicationWindow: UIWindow?
    var window: UIWindow?
    var apiClient:ApiClientProtocol?
    var configType:ConfigType = .bitbucket
    
    var report:Report = Report()
    private var isInitialized:Bool = false
    private var shouldPostInitializedEvent:Bool = true
    
    @objc public var recordingEnabled = false
    
    private var logoutShown = false
    
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
        
        apiClient?.addIssue(
            title: report.title,
            content: IssueContentProvider.createContent(from: report),
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
        if !logoutShown {
            logoutShown = true
            showModal(viewController: Utils.createAlert(title: "Logout", message: "Do you want to logout?", positiveAction: {
                self.logout()
                self.logoutShown = false
            }, negativeAction: {
                self.logoutShown = false
            }))
        }
    }
    
    
    @objc func showReportDialog(_ recognizer: UITapGestureRecognizer) {
        debuggItButton.isHidden = true
        takeScreenshot()
        debuggItButton.isHidden = false
        if (apiClient?.hasToken)! {
            showModal(viewController: Initializer.viewController(EditScreenshotModalViewController.self))
        } else {
            showLoginModal()
        }
    }
    
    func showLoginModal() {
        IQKeyboardManager.sharedManager().enable = true
        
        if configType == .jira {
            showModal(viewController: Initializer.viewController(LoginModalViewController.self))
        } else {
            let loginViewController = Initializer.viewController(WebViewController.self)
            loginViewController.url = apiClient?.loginUrl
            
            let navigationController = UINavigationController(rootViewController: loginViewController)
            navigationController.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: loginViewController, action: #selector(loginViewController.dismiss(_:)))
            navigationController.navigationBar.topItem?.title = "Sign in"
            
            showModal(viewController: navigationController)
        }
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
    
    func showModal(viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        if window == nil {
            applicationWindow = UIApplication.shared.keyWindow
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = UIViewController()
            window?.windowLevel = UIWindowLevelAlert + 1
            window?.makeKeyAndVisible()
        }
        
        viewController.modalPresentationStyle = .overCurrentContext
        window?.rootViewController?.present(viewController, animated: animated, completion: completion)
    }
    
    func moveApplicationWindowToFront() {
        self.window?.isHidden = true
        self.window = nil
        self.applicationWindow?.makeKeyAndVisible()
    }
    
    
    private func registerShakeDetector() {
        //todo add shake gesture listener
    }
    
}
