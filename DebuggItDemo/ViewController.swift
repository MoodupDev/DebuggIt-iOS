//
//  ViewController.swift
//  DebuggItDemo
//
//  Created by Arkadiusz Żmudzin on 10.01.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: "https://debugg.it/") else { return }
        self.webView.load(URLRequest(url: url))
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
