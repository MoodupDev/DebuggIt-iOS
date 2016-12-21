//
//  UIViewController+EmbedInContainer.swift
//  Pods
//
//  Created by Arkadiusz Żmudzin on 25.11.2016.
//
//

import Foundation
import UIKit

extension UIViewController {
    
    func embed(_ viewController: UIViewController, in container: UIView) {
        self.addChildViewController(viewController)
        viewController.view.frame = CGRect(x: 0, y: 0, width: container.frame.size.width, height: container.frame.size.height)
        container.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
}
