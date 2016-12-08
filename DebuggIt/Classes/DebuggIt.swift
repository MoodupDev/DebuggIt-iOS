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
    var debuggItButton: DebuggItButton!
    
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
    
    var isFirstRun: Bool {
        get {
            let defaults = UserDefaults.standard
            return !defaults.bool(forKey: Constants.firstRunKey)
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(isFirstRun, forKey: Constants.firstRunKey)
            defaults.synchronize()
        }
    }
    
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
        isInitialized = true
        ApiClient.postEvent(.initialized)
    }
    
    func attach(to viewController: UIViewController) throws -> Void {
        if(!isInitialized) {
            throw DebuggItError.notInitialized(message: "Call init before attach")
        } else {
            if(shouldPostInitializedEvent) {
                ApiClient.postEvent(.initialized)
                shouldPostInitializedEvent = false
            }
            //TODO: add version checking
            
            currentViewController = viewController
            
            registerShakeDetector()
            addReportButton()
            
            if isFirstRun {
                do {
                    try apiClient?.keychain.removeAll()
                } catch let error {
                    print("\(#function): error when removing all keychain keys: \(error)")
                }
                //TODO: open first run dialog
                isFirstRun = false
            }
        }
    }
    
    func sendReport(successBlock: @escaping () -> (), errorBlock: @escaping (_ statusCode: Int?,_ message: String?) -> ()) {
        
        apiClient?.addIssue(
            title: report.title,
            content: IssueContentProvider.createContent(from: report),
            priority: report.priority.name(),
            kind: report.kind.name(),
            successBlock: successBlock,
            errorBlock: errorBlock)
    }
    
    private func addReportButton() {
        removeReportButtonIfExists()
        let debuggItButton = DebuggItButton.instantiateFromNib()
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
        
        self.debuggItButton = debuggItButton
    }
    
    private func removeReportButtonIfExists() {
        for subview in currentViewController!.view.subviews {
            if subview is DebuggItButton {
                subview.removeFromSuperview()
            }
        }
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
                self.moveApplicationWindowToFront()
            }, negativeAction: {
                self.logoutShown = false
                self.moveApplicationWindowToFront()
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
        
        if configType == .jira {
            showModal(viewController: Initializer.viewController(LoginModalViewController.self))
        } else {
            let loginViewController = Initializer.viewController(WebViewController.self)
            loginViewController.url = apiClient?.loginUrl
            
            let navigationController = UINavigationController(rootViewController: loginViewController)
            navigationController.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: loginViewController, action: #selector(loginViewController.dismiss(_:)))
            navigationController.navigationBar.topItem?.title = "alert.title.login".localized()
            
            showModal(viewController: navigationController)
        }
    }
    
    @objc func moveButton(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed, let view = recognizer.view {
            let translation = recognizer.translation(in: view)
            if(translation.y < 0.0 && view.center.y > (view.frame.height / 2)
                || translation.y >= 0.0 && view.center.y < ((currentViewController?.view.frame.maxY)! - (view.frame.height/2))) {
                view.center = CGPoint(x: view.center.x, y: view.center.y + translation.y)
                recognizer.setTranslation(CGPoint.zero, in: view)
            }
        }
    }
    
    private func takeScreenshot() {
        let window: UIWindow! = UIApplication.shared.keyWindow
        report.currentScreenshot = window.capture()
    }
    
    func showModal(viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        if window == nil {
            applicationWindow = UIApplication.shared.keyWindow
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = UIViewController()
            window?.windowLevel = UIWindowLevelAlert + 1
            window?.makeKeyAndVisible()
        }
        IQKeyboardManager.sharedManager().enable = true
        viewController.modalPresentationStyle = .overCurrentContext
        window?.rootViewController?.present(viewController, animated: animated, completion: completion)
    }
    
    func moveApplicationWindowToFront() {
        IQKeyboardManager.sharedManager().enable = false
        self.window?.isHidden = true
        self.window = nil
        self.applicationWindow?.makeKeyAndVisible()
    }
    
    
    private func registerShakeDetector() {
        //todo add shake gesture listener
    }
    
}
