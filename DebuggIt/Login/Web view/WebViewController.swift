//
//  WebViewViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 18.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    var url: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        self.webView.loadRequest(URLRequest(url: URL(string: url!)!))
    }
    
    @objc func dismiss(_ sender: AnyObject?) {
        self.dismiss(animated: true, completion: {
            DebuggIt.sharedInstance.moveApplicationWindowToFront()
        })
    }
}

extension WebViewController : UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        if isCallback(request.url) {
            if let code = request.url?.queryParams()["code"] {
                exchangeCodeForAccessToken(code)
            }
            return false
        }
        return true
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
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loadIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadIndicator.stopAnimating()
    }
}
