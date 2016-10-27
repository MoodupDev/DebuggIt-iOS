//
//  ViewController.swift
//  DebugIt
//
//  Created by Bartek on 26/10/16.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        do {
            try DebuggIt.sharedInstance.attach(viewController: self)
        } catch DebuggItError.notInitialized(let message) {
            print(message)
        } catch {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

