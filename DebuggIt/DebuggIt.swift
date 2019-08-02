//
//  DebuggIt.swift
//  DebuggIt
//
//  Created by Bartek on 25/10/16.
//  Copyright © 2016 Mood Up. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Reachability
import AWSS3

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
    
    let reachability = Reachability()!
    
    var apiClient: ApiClientProtocol?
    var storageClient: ApiStorageProtocol?
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
    
    fileprivate var debuggItButton: DebuggItButton!
    fileprivate var buttonHeightContraint: NSLayoutConstraint!
    private var currentWindow: UIWindow?
    
    private var applicationWindow: UIWindow?
    private var window: UIWindow?
    
    private var logoutShown = false
    
    private var versionSupported = false

    private var buttonYMultiplier: CGFloat = 0.5
    // MARK: - Public methods
    
    @discardableResult @objc public func initBitbucket(repoSlug: String, accountName: String) -> DebuggIt {
        apiClient = BitbucketApiClient(repoSlug: repoSlug, accountName: accountName)
        return initDebuggIt(configType: .bitbucket)
    }
    
    @discardableResult @objc public func initJira(host: String, projectKey: String, usesHttps: Bool = true) -> DebuggIt {
        apiClient = JiraApiClient(host: host, projectKey: projectKey, usesHttps: usesHttps)
        return initDebuggIt(configType: .jira)
    }
    
    @discardableResult @objc public func initGithub(repoSlug: String, accountName: String) -> DebuggIt {
        apiClient = GitHubApiClient(repoSlug: repoSlug, accountName: accountName)
        return initDebuggIt(configType: .github)
    }
    
    @discardableResult @objc public func initAWS(bucketName: String, regionType: AWSRegionType, identityPool: String) -> DebuggIt {
        storageClient = AWSClient(bucketName: bucketName, regionType: regionType, identityPool: identityPool)
        return self
    }
    
    @discardableResult @objc public func initDefaultStorage(url: String, imagePath: String, audioPath: String) -> DebuggIt {
        guard let url = URL(string: url) else {
            print("Failed to initialize DebuggIt - wrong base url")
            return self
        }
        storageClient = ApiClient(url: url, imagePath: imagePath, audioPath: audioPath)
        return self
    }
    
    @discardableResult @objc public func initCustomStorage(
        uploadImage: @escaping ((String, ApiClientDelegate) -> ()),
        uploadAudio: @escaping ((String, ApiClientDelegate) -> ())) -> DebuggIt {
        
        storageClient = ApiClient(uploadImage: uploadImage, uploadAudio: uploadAudio)
        return self
    }
    
    // MARK: - Methods
    
    func initDebuggIt(configType:ConfigType) -> DebuggIt {
        self.configType = configType
        swizzleMethod(of: UIWindow.self, original: #selector(setter: UIWindow.self.rootViewController), to: #selector(UIWindow.self.attachDebuggItOnRootViewControllerChange(_:)))
        NotificationCenter.default.addObserver(self, selector: #selector(self.attachToWindow(_:)), name: UIWindow.didBecomeKeyNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDebuggitButtonContraint), name: UIDevice.orientationDidChangeNotification, object: nil)
        initReachability()
        
        guard let bundle = Bundle(identifier: "com.moodup.DebuggIt")
            else { return self }
        let fonts = [
            bundle.url(forResource: "Montserrat-Regular", withExtension: "ttf"),
            bundle.url(forResource: "Montserrat-Black", withExtension: "ttf"),
            bundle.url(forResource: "Montserrat-BlackItalic", withExtension: "ttf"),
            bundle.url(forResource: "Montserrat-Bold", withExtension: "ttf"),
            bundle.url(forResource: "Montserrat-BoldItalic", withExtension: "ttf"),
            bundle.url(forResource: "Montserrat-ExtraBold", withExtension: "ttf"),
            bundle.url(forResource: "Montserrat-ExtraBoldItalic", withExtension: "ttf"),
            bundle.url(forResource: "Montserrat-ExtraLight", withExtension: "ttf"),
            bundle.url(forResource: "Montserrat-ExtraLightItalic", withExtension: "ttf"),
            bundle.url(forResource: "Montserrat-Italic", withExtension: "ttf"),
            bundle.url(forResource: "Montserrat-Light", withExtension: "ttf"),
            bundle.url(forResource: "Montserrat-LightItalic", withExtension: "ttf"),
            bundle.url(forResource: "Montserrat-Medium", withExtension: "ttf"),
            bundle.url(forResource: "Montserrat-MediumItalic", withExtension: "ttf"),
            bundle.url(forResource: "Montserrat-SemiBold", withExtension: "ttf"),
            bundle.url(forResource: "Montserrat-SemiBoldItalic", withExtension: "ttf"),
            bundle.url(forResource: "Montserrat-Thin", withExtension: "ttf"),
            bundle.url(forResource: "Montserrat-ThinItalic", withExtension: "ttf")
            ]
        
        fonts.forEach({ url in
            guard let url = url,
                let dataProvider = CGDataProvider(url: url as CFURL),
                let font = CGFont(dataProvider)
                else { return }
            
            CTFontManagerRegisterGraphicsFont(font, nil)
        })
        
        return self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initReachability() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func attachToWindow(_ notification: Notification) {
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
    
    
    func resetButtonImage() {
        DispatchQueue.main.async {
            self.debuggItButton.imageView.image = Initializer.image(named: "logoBugSmall")
        }
    }
    
    private func addReportButton(to containter: UIView) {
        let nextScreenshotImage = Initializer.image(named: "nextScreenshoot")
        let isWithScreenshotImage = self.debuggItButton == nil ? false : (self.debuggItButton.imageView.image == nextScreenshotImage)
        removeReportButtonIfExists(from: containter)
        let button = createReportButton()
        if isWithScreenshotImage {
            button.imageView.image = nextScreenshotImage
        }
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
    
    @objc func updateDebuggitButtonContraint() {
        buttonHeightContraint.constant = (self.buttonYMultiplier * UIScreen.main.bounds.height) - (debuggItButton.frame.height / 2)
    }
    
    private func addConstraints(for view : UIView, in container: UIView) {
        buttonHeightContraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: ((self.buttonYMultiplier * UIScreen.main.bounds.height) - (view.frame.height / 2)))
        container.addConstraint(buttonHeightContraint)
        
        container.addConstraint(NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: container, attribute: .right, multiplier: 1.0, constant: 0.0))
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
            URLSession.shared.reset {
                DispatchQueue.main.async {
                    let loginViewController = Initializer.viewController(WebViewController.self)
                    loginViewController.url = self.apiClient?.loginUrl
                    
                    let navigationController = UINavigationController(rootViewController: loginViewController)
                    navigationController.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: loginViewController, action: #selector(loginViewController.dismiss(_:)))
                    navigationController.navigationBar.topItem?.title = "alert.title.login".localized()
                    
                    self.showModal(viewController: navigationController)
                }
            }
        }
    }
    
    @objc func moveButton(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed, let view = recognizer.view {
            let translation = recognizer.translation(in: view)
            if(translation.y < 0.0 && view.center.y > (view.frame.height / 2)
                || translation.y >= 0.0 && view.center.y < ((currentWindow?.frame.maxY)! - (view.frame.height/2))) {
                view.center = CGPoint(x: view.center.x, y: view.center.y + translation.y)
                self.buttonYMultiplier = view.center.y / UIScreen.main.bounds.height
                recognizer.setTranslation(CGPoint.zero, in: view)
            }
        }
        
        if recognizer.state == .ended, let view = recognizer.view {
            buttonHeightContraint.constant = (self.buttonYMultiplier * UIScreen.main.bounds.height) - (view.frame.height / 2)
        }
    }
    
    private func takeScreenshot() {
        let window: UIWindow! = UIApplication.shared.keyWindow
        report.currentScreenshotScreenName = getVisibleViewControllerName(from: window)
        report.currentScreenshot = window.capture()
    }
    
    func changeButtonImageToScreenshot() {
        DispatchQueue.main.async {
            self.debuggItButton.imageView.image = Initializer.image(named: "nextScreenshoot")
        }
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
            window?.windowLevel = UIWindow.Level.alert + 1
            window?.makeKeyAndVisible()
        }
        IQKeyboardManager.shared.enable = true
        viewController.modalPresentationStyle = .overCurrentContext
        window?.rootViewController?.present(viewController, animated: animated, completion: completion)
        
    }
    
    func moveApplicationWindowToFront() {
        IQKeyboardManager.shared.enable = false
        self.window?.isHidden = true
        self.window = nil
        self.applicationWindow?.makeKeyAndVisible()
    }
    
    private func swizzleMethod(of anyClass: AnyClass, original originalSelector: Selector, to swizzledSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(anyClass, originalSelector),
            let swizzledMethod = class_getInstanceMethod(anyClass, swizzledSelector) else { return }
    
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    class DebuggItWindow : UIWindow {}
}

extension UIWindow {
    
    @objc func attachDebuggItOnRootViewControllerChange(_ viewController: UIViewController) {
        attachDebuggItOnRootViewControllerChange(viewController)
        guard !(self is DebuggIt.DebuggItWindow) && self.isKeyWindow else { return }
        DebuggIt.sharedInstance.removeReportButtonIfExists(from: self)
        DebuggIt.sharedInstance.reattach(to: self.rootViewController!)
        viewController.becomeFirstResponder()
    }
}

extension DebuggIt: BugDescriptionPage1Delegate {
    func bugDescriptionPageOneDidClickAddNewScreenshot(_ viewController: BugDescriptionPage1ViewController) {
        viewController.dismiss(animated: true) {
            self.changeButtonImageToScreenshot()
            self.moveApplicationWindowToFront()
            IQKeyboardManager.shared.enable = false
        }
    }
}

extension UIViewController {
    
    open override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if motion == .motionShake {
            DebuggIt.sharedInstance.showReportDialog()
        }
    }
}
