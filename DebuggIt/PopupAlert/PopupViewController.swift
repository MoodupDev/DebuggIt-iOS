//
//  PopupViewController.swift
//  DebuggIt
//
//  Created by Mikołaj Pęcak on 25.08.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var alertTextView: UITextView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var breakLineView: UIView!
    var willShowDebuggItWindow = false
    
    func setup(willShowNextWindow: Bool, alertText: String, positiveAction: Bool, isProgressPopup: Bool) {
        self.willShowDebuggItWindow = willShowNextWindow
        self.alertTextView.text = alertText
        if positiveAction {
            thumbImageView.image = Initializer.image(named: "thumbsUp")
        } else {
            thumbImageView.image = Initializer.image(named: "thumbsDown")
        }
        if isProgressPopup {
            self.okButton.removeFromSuperview()
            self.breakLineView.removeFromSuperview()
            self.thumbImageView.isHidden = true
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: {
            completion?()
            if !(self.willShowDebuggItWindow) {
                DebuggIt.sharedInstance.moveApplicationWindowToFront()
            }
        })
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            if self.willShowDebuggItWindow {
                DebuggIt.sharedInstance.showModal(viewController: Initializer.viewController(BugDescriptionViewController.self))
            }
        })
    }
}
