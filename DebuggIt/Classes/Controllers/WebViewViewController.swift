//
//  WebViewViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 18.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class WebViewViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var url: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        self.webView.loadRequest(URLRequest(url: URL(string: url!)!))
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension WebViewViewController : UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if isCallback(request.url) {
            if let code = request.url?.queryParams()["code"] {
                exchangeCodeForAccessToken(code)
            }
            return false
        }
        return true
    }
    
    func isCallback(_ url: URL?) -> Bool {
        if let url = url {
            return url.queryParams()["code"] != nil
        }
        return false
    }
    
    func exchangeCodeForAccessToken(_ code: String) {
        let loadingAlert = Utils.createAlert(title: "alert.title.login".localized(), message: "alert.message.login".localized())
        self.present(loadingAlert, animated: true, completion: nil)
        DebuggIt.sharedInstance.apiClient?.exchangeAuthCodeForToken(code, successBlock: { [unowned self] in
            loadingAlert.dismiss(animated: true, completion: nil)
            self.present(Utils.createAlert(title: "alert.title.login".localized(), message: "alert.message.login.successful".localized(), positiveAction: {
                self.dismiss(animated: true, completion: nil)
                let editScreenshotViewController = Initializer.viewController(EditScreenshotModalViewController.self)
                editScreenshotViewController.modalPresentationStyle = .overCurrentContext
                UIApplication.shared.keyWindow?.rootViewController?.present(editScreenshotViewController, animated: true, completion: nil)
            }), animated: true, completion: nil)
            }, errorBlock: { (status, errorMessage) in
                print(status ?? "status", errorMessage ?? "error")
        })
    }
}
