//
//  WelcomeViewController.swift
//  Pods
//
//  Created by Arkadiusz Żmudzin on 08.12.2016.
//
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var viewModel = WelcomeViewModel()
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: {
            completion?()
            self.viewModel.moveApplicationWindowToFront()
        })
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.viewModel.didShowWelcomeScreen()
        self.dismiss(animated: true, completion: nil)
    }
}
