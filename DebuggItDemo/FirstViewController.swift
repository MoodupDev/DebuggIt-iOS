//
//  ViewController.swift
//  DebuggItDemo
//
//  Created by Arkadiusz Żmudzin on 10.01.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import UIKit
import WebKit

class FirstViewController: BaseViewController {
    
    private let url = "https://debugg.it/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addWebView(self.url)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}