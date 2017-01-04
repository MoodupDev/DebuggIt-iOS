//
//  DebuggIt.swift
//  DebuggIt
//
//  Created by Bartek on 25/10/16.
//  Copyright © 2016 Mood Up. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

enum ConfigType {
    case jira
    case github
    case bitbucket
}

@objc
public class DebuggIt: NSObject {
    
    // MARK: - Public properties
    
    @objc public static let sharedInstance = DebuggIt()
    @objc public var recordingEnabled = false
    
    // MARK: - Properties
    
    var apiClient: ApiClientProtocol?
    var configType: ConfigType = .bitbucket
    var report: Report = Report()
    
    var welcomeScreenHasBeenShown: Bool {
        get {
            let defaults = UserDefaults.standard
            return defaults.bool(forKey: Constants.welcomeScreenHasBeenShownKey)
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: Constants.welcomeScreenHasBeenShownKey)
            defaults.synchronize()
        }
    }
    
    private var debuggItButton: DebuggItButton!
    private var currentWindow: UIWindow?
    
    private var applicationWindow: UIWindow?
    private var window: UIWindow?
    
    private var logoutShown = false
    
    // MARK: - Public methods
    
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
    
    // MARK: - Methods
    
    func initDebugIt(configType:ConfigType) {
        self.configType = configType
        ApiClient.postEvent(.initialized)
        swizzleMethod(of: UIWindow.self, original: #selector(setter: UIWindow.self.rootViewController), to: #selector(UIWindow.self.attachDebuggItOnRootViewControllerChange(_:)))
        NotificationCenter.default.addObserver(self, selector: #selector(self.attachToWindow(_:)), name: NSNotification.Name.UIWindowDidBecomeKey, object: nil)
    }
    
    func attachToWindow(_ notification: Notification) {
        guard let window = notification.object as? UIWindow, !(window is DebuggItWindow) else { return }
        attach(to: window)
    }
    
    func attach(to window: UIWindow) {
        currentWindow = window
        
        removeReportButtonIfExists(from: window.rootViewController!.view)
        addReportButton(to: window)
        
        if !welcomeScreenHasBeenShown {
            TokenManager.sharedManager.removeAll()
            
            showModal(viewController: Initializer.viewController(WelcomeViewController.self))
        }

    }
    
    func reattach(to viewController: UIViewController) {
        addReportButton(to: viewController.view)
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
    
    private func addReportButton(to containter: UIView) {
        removeReportButtonIfExists(from: containter)
        let button = createReportButton()
        
        containter.addSubview(button)
        addConstraints(for: button, in: containter)
        
        self.debuggItButton = button
    }
    
    private func createReportButton() -> DebuggItButton {
        let button = DebuggItButton.instantiateFromNib()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(showReportDialog))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action:#selector(moveButton(_:)))
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(handleLongPress(_:)))
        
        button.addGestureRecognizer(tapGestureRecognizer)
        button.addGestureRecognizer(panGestureRecognizer)
        button.addGestureRecognizer(longPressGestureRecognizer)
        return button

    }
    
    func removeReportButtonIfExists(from view: UIView) {
        for subview in view.subviews {
            if subview is DebuggItButton {
                subview.removeFromSuperview()
            }
        }
    }
    
    
    private func addConstraints(for view : UIView, in container: UIView) {
        container.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0))
        
        container.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0.0))
    }
    
    private func logout() {
        report = Report()
        apiClient?.clearTokens()
        Utils.clearWebViewCookies()
    }
    
    @objc func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
        if (apiClient?.hasToken)! {
            if !logoutShown {
                logoutShown = true
                showModal(viewController: Utils.createAlert(title: "alert.title.logout".localized(), message: "alert.message.logout".localized(), positiveAction: {
                    self.logout()
                    self.logoutShown = false
                    self.moveApplicationWindowToFront()
                }, negativeAction: {
                    self.logoutShown = false
                    self.moveApplicationWindowToFront()
                }))
            }
        } else {
            showReportDialog()
        }
    }
    
    
    @objc func showReportDialog() {
        debuggItButton.isHidden = true
        takeScreenshot()
        debuggItButton.isHidden = false
        if (apiClient?.hasToken)! {
            showModal(viewController: Initializer.viewController(EditScreenshotModalViewController.self))
        } else {
            showLoginModal()
        }
    }
    
    private func showLoginModal() {
        
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
                || translation.y >= 0.0 && view.center.y < ((currentWindow?.frame.maxY)! - (view.frame.height/2))) {
                view.center = CGPoint(x: view.center.x, y: view.center.y + translation.y)
                recognizer.setTranslation(CGPoint.zero, in: view)
            }
        }
    }
    
    private func takeScreenshot() {
        let window: UIWindow! = UIApplication.shared.keyWindow
        report.currentScreenshotScreenName = getVisibleViewControllerName(from: window)
        report.currentScreenshot = window.capture()
    }
    
    private func getVisibleViewControllerName(from window: UIWindow) -> String {
        var viewController = window.rootViewController
        if viewController is UINavigationController {
            viewController = (viewController as! UINavigationController).visibleViewController
        }
        return String(describing: type(of: viewController!))
    }
    
    func showModal(viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        if window == nil {
            applicationWindow = UIApplication.shared.keyWindow
            
            window = DebuggItWindow(frame: UIScreen.main.bounds)
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
    
    private override init() {
        
    }
    
    private func swizzleMethod(of anyClass: AnyClass, original originalSelector: Selector, to swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(anyClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(anyClass, swizzledSelector)
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    class DebuggItWindow : UIWindow {}
}

extension UIWindow {
    
    func attachDebuggItOnRootViewControllerChange(_ viewController: UIViewController) {
        attachDebuggItOnRootViewControllerChange(viewController)
        guard !(self is DebuggIt.DebuggItWindow) && self.isKeyWindow else { return }
        DebuggIt.sharedInstance.removeReportButtonIfExists(from: self)
        DebuggIt.sharedInstance.reattach(to: self.rootViewController!)
    }
}

