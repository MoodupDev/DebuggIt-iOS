//
//  BaseViewController.swift
//  DebuggItDemo
//
//  Created by Piotr Gomoła on 05/08/2019.
//  Copyright © 2019 Mood Up. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class BaseViewController: UIViewController {
    
    func addWebView(_ url: String) {
        guard let url = URL(string: url) else { return }
        
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: self.view.frame, configuration: config)
        webView.load(URLRequest(url: url))
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(webView)
        
        let top = webView.topAnchor.constraint(equalTo: view.topAnchor)
        let bottom = webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let leading = webView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        view.addConstraints([top, bottom, leading, trailing])
    }
}
