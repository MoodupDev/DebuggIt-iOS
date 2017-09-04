//
//  WelcomeViewController.swift
//  Pods
//
//  Created by Arkadiusz Żmudzin on 08.12.2016.
//
//

import UIKit

class WelcomeViewController: UIViewController {
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: {
            completion?()
            DebuggIt.sharedInstance.moveApplicationWindowToFront()
        })
    }
    
    @IBAction func close(_ sender: UIButton) {
        DebuggIt.sharedInstance.welcomeScreenHasBeenShown = true
        self.dismiss(animated: true, completion: nil)
    }
}
