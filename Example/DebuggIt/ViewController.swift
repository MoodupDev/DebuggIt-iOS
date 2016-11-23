//
//  ViewController.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 11/23/2016.
//  Copyright (c) 2016 Arkadiusz Żmudzin. All rights reserved.
//

import UIKit
import DebuggIt

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try DebuggIt.sharedInstance.attach(viewController: self)
        } catch DebuggItError.notInitialized(let message) {
            print(message)
        } catch {
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

