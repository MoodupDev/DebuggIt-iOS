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

private let isDebuggItViewController: (UIViewController.Type) -> Bool = { viewController in
    return viewController is DebuggItViewControllerProtocol.Type
}

private func attachDebuggIt(to viewController: UIViewController?) {
    if let viewController = viewController, isDebuggItViewController(type(of: viewController)) {
        do {
            try DebuggIt.sharedInstance.attach(viewController: viewController)
        } catch {
            print(#function, error)
        }
    }
}

extension UIViewController {
    
    open override class func initialize() {
        
        guard self === UIViewController.self else { return }
        swizzleMethod(of: self, original: #selector(self.viewWillAppear(_:)), to: #selector(self.viewWillAppearWithAttach(_:)))
    }
    
    // MARK: - Swizzled methods
    
    func viewWillAppearWithAttach(_ animated: Bool) {
        self.viewWillAppearWithAttach(animated)
        attachDebuggIt(to: self)
    }
}
