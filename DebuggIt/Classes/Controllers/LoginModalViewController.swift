//
//  LoginModalViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 27.10.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit
import SwiftyJSON
import IQKeyboardManagerSwift

class LoginModalViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var twoFactorCodeTextField: UITextField!
    @IBOutlet weak var background: UIView!
    
    // MARK: Overriden
    
    override func viewDidLoad() {
        super.viewDidLoad()
        twoFactorCodeTextField.delegate = self
        updateLoginInfoSection()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(close(_:)))
        background.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enable = false
    }
    
    // MARK: Actions
    
    func close(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        DebuggIt.sharedInstance.applicationWindow?.makeKey()
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        let loadingAlert = Utils.createAlert(title: "alert.title.login".localized(), message: "alert.message.login".localized())
        
        self.present(loadingAlert, animated: true, completion: nil)
        
        DebuggIt.sharedInstance.apiClient?.login(email: email, password: password, successBlock: { [unowned self] (response) in
            loadingAlert.dismiss(animated: true, completion: nil)
            self.present(Utils.createAlert(title: "alert.title.login".localized(), message: "alert.message.login.successful".localized(), positiveAction: {
                self.dismiss(animated: true, completion: nil)
                let editScreenshotViewController = EditScreenshotModalViewController()
                editScreenshotViewController.modalPresentationStyle = .overCurrentContext
                UIApplication.shared.keyWindow?.rootViewController?.present(editScreenshotViewController, animated: true, completion: nil)
            }), animated: true, completion: nil)
            }, errorBlock: { [unowned self] (status, error) in
                loadingAlert.dismiss(animated: true, completion: nil)
                if let errorMessage = error {
                    let message = Utils.parseError(errorMessage, defaultMessage: "error.login.wrong.credentials".localized())
                    if message.contains("two-factor") {
                        self.twoFactorCodeTextField.superview?.isHidden = false
                        self.present(Utils.createAlert(title: "alert.title.failure".localized(), message: "error.2fa.code".localized(), positiveAction: {}), animated: true, completion: nil)
                    } else {
                        self.present(Utils.createAlert(title: "alert.title.failure".localized(), message: message, positiveAction: {}), animated: true, completion: nil)
                        
                    }
                } else {
                    self.present(Utils.createAlert(title: "alert.title.failure".localized(), message: "error.general".localized(), positiveAction: {}), animated: true, completion: nil)
                }
        })
    }
    
    func updateLoginInfoSection() {
        switch DebuggIt.sharedInstance.configType {
        case .bitbucket:
            serviceImageView.image = Initializer.image(named: "bitbucket")
            infoLabel.text = String(format: "login.text".localized(), "Bitbucket")
        case .github:
            serviceImageView.image = Initializer.image(named: "github")
            infoLabel.text = String(format: "login.text".localized(), "GitHub")
        case .jira:
            serviceImageView.image = Initializer.image(named: "jira")
            infoLabel.text = String(format: "login.text".localized(), "JIRA")
        }
    }
    
}

extension LoginModalViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        (DebuggIt.sharedInstance.apiClient as! GitHubApiClient).twoFactorAuthCode = textField.text
    }
}
