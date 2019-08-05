//
//  SecondViewController.swift
//  DebuggItDemo
//
//  Created by Piotr Gomoła on 02/08/2019.
//  Copyright © 2019 Mood Up. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class SecondViewController: BaseViewController {
    
    private let url = "https://moodup.team/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addWebView(url)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
