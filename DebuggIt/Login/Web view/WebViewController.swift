//
//  WebViewViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 18.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    var url: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: url!)!))
    }
    
    @objc func dismiss(_ sender: AnyObject?) {
        self.dismiss(animated: true, completion: {
            DebuggIt.sharedInstance.moveApplicationWindowToFront()
        })
    }
}

extension WebViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if isCallback(navigationAction.request.url) {
            if let code = navigationAction.request.url?.queryParams()["code"] {
                exchangeCodeForAccessToken(code)
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func isCallback(_ url: URL?) -> Bool {
        return (url?.absoluteString.contains(Constants.Bitbucket.callbackUrl))! && url?.queryParams()["code"] != nil
    }
    
    func exchangeCodeForAccessToken(_ code: String) {
        let loadingAlert = Utils.createAlert(title: "alert.title.login".localized(), message: "alert.message.login".localized())
        self.present(loadingAlert, animated: true, completion: nil)
        DebuggIt.sharedInstance.apiClient?.exchangeAuthCodeForToken(code, successBlock: { [unowned self] in
            loadingAlert.dismiss(animated: true, completion: {
                self.present(Utils.createAlert(title: "alert.title.login.successful".localized(), message: "alert.message.login.successful".localized(), positiveAction: {
                    self.dismiss(animated: true, completion: nil)
                    let editScreenshotViewController = Initializer.viewController(EditScreenshotModalViewController.self)
                    editScreenshotViewController.modalPresentationStyle = .overCurrentContext
                    DebuggIt.sharedInstance.showModal(viewController: editScreenshotViewController)
                }), animated: true, completion: nil)
            })
            }, errorBlock: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadIndicator.stopAnimating()
    }
}
