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
    
    // MARK: Overriden
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLoginInfoSection()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enable = false
    }
    
    // MARK: Actions
    
    @IBAction func signIn(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        DebuggIt.sharedInstance.apiClient?.login(email: email, password: password, successBlock: { (response) in
            self.dismiss(animated: true, completion: {
                UIApplication.shared.keyWindow?.rootViewController?.present(EditScreenshotModalViewController(), animated: true, completion: nil)
            })
            }, errorBlock: { (status, error) in
                let json = JSON.parse(error!)
                self.present(Utils.createAlert(title: "Error", message: json["error_description"].stringValue, positiveAction: nil, negativeAction: nil), animated: true, completion: nil)
        })
    }
    
    func updateLoginInfoSection() {
        switch DebuggIt.sharedInstance.configType {
        case .bitbucket:
            serviceImageView.image = UIImage(named: "bitbucket")
            infoLabel.text = String(format: "login.text".localized(), "Bitbucket")
        case .github:
            serviceImageView.image = UIImage(named: "github")
            infoLabel.text = String(format: "login.text".localized(), "GitHub")
        case .jira:
            serviceImageView.image = UIImage(named: "jira")
            infoLabel.text = String(format: "login.text".localized(), "JIRA")
        }
    }
    
}
