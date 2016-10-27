//
//  LoginModalViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 27.10.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class LoginModalViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Overriden
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Actions
    
    @IBAction func signIn(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        DebuggIt.sharedInstance.apiClient?.login(email: email, password: password, successBlock: { (result) in
            print(result)
            }, errorBlock: { (status, error) in
                print(status, error)
        })
    }

}
