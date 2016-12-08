//
//  UIViewController+AttachOnViewDidLoad.swift
//  Pods
//
//  Created by Arkadiusz Żmudzin on 30.11.2016.
//
//

import Foundation
import UIKit

private func swizzleMethod(of viewController: UIViewController.Type, original originalSelector: Selector, to swizzledSelector: Selector) {
    let originalMethod = class_getInstanceMethod(viewController, originalSelector)
    let swizzledMethod = class_getInstanceMethod(viewController, swizzledSelector)
    
    method_exchangeImplementations(originalMethod, swizzledMethod)
}

private func attachDebuggIt(to viewController: UIViewController) {
    if viewController is DebuggItViewControllerProtocol {
        do {
            try DebuggIt.sharedInstance.attach(to: viewController)
            viewController.becomeFirstResponder()
        } catch let error {
            fatalError("\(#function): \(error)")
        }
    }
}

extension UIViewController {
    
    open override class func initialize() {
        
        guard self === UIViewController.self else { return }
        swizzleMethod(of: self, original: #selector(getter: self.canBecomeFirstResponder), to: #selector(getter: self.canBecomeFirstResponderForShake))
        swizzleMethod(of: self, original: #selector(self.motionEnded(_:with:)), to: #selector(self.motionEndedForShake(_:with:)))
        swizzleMethod(of: self, original: #selector(self.viewDidAppear(_:)), to: #selector(self.viewDidAppearWithAttach(_:)))
    }
    
    // MARK: - Swizzled methods
    
    func viewDidAppearWithAttach(_ animated: Bool) {
        self.viewDidAppearWithAttach(animated)
        attachDebuggIt(to: self)
    }
    
    var canBecomeFirstResponderForShake: Bool {
        return self is DebuggItViewControllerProtocol
    }
    
    func motionEndedForShake(_ motion: UIEventSubtype, with event: UIEvent?) {
        if self is DebuggItViewControllerProtocol && motion == .motionShake {
            DebuggIt.sharedInstance.showReportDialog()
        }
    }
    
    
}
