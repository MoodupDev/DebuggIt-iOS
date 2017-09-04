//
//  BugDescriptionViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 03.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class BugDescriptionViewController: UIViewController {
    
    private let titleMaxCharacters = 255;
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var container: UIView!
    var pageViewController : BugDescriptionPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController = BugDescriptionPageViewController()
        pageViewController.pageControl = self.pageControl
        
        self.embed(pageViewController, in: container)
    }
    
    // MARK: Actions
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        self.resignFirstResponder()
        self.sendReport()
    }
    
    private func sendReport() {
        let title = DebuggIt.sharedInstance.report.title
        if title.isEmpty {
            self.dismiss(animated: true, completion: {
                let popup = Initializer.viewController(PopupViewController.self)
                DebuggIt.sharedInstance.showModal(viewController: popup)
                popup.willShowDebuggItWindow = true
                popup.thumbImageView.image = Initializer.image(named: "thumbsDown")
                popup.alertTextView.text = "error.title.empty".localized()
            })
        } else if title.characters.count > titleMaxCharacters {
            self.dismiss(animated: true, completion: {
                let popup = Initializer.viewController(PopupViewController.self)
                DebuggIt.sharedInstance.showModal(viewController: popup)
                popup.willShowDebuggItWindow = true
                popup.thumbImageView.image = Initializer.image(named: "thumbsDown")
                popup.alertTextView.text = "error.title.too.long".localized()
            })
        } else {
            let progressPopup = Initializer.viewController(PopupViewController.self)
            self.dismiss(animated: true, completion: {
                DebuggIt.sharedInstance.showModal(viewController: progressPopup)
                progressPopup.willShowDebuggItWindow = true
                progressPopup.thumbImageView.image = Initializer.image(named: "thumbsUp")
                progressPopup.alertTextView.text = "alert.message.wait".localized()
                progressPopup.okButton.removeFromSuperview()
                progressPopup.breakLineView.removeFromSuperview()
                progressPopup.thumbImageView.isHidden = true
            })
            
            DebuggIt.sharedInstance.sendReport(
                successBlock: {
                    progressPopup.dismiss(animated: true, completion: {
                        let popup = Initializer.viewController(PopupViewController.self)
                        DebuggIt.sharedInstance.showModal(viewController: popup)
                        popup.willShowDebuggItWindow = false
                        popup.thumbImageView.image = Initializer.image(named: "thumbsUp")
                        popup.alertTextView.text = "alert.message,saved.report".localized()
                    })
                    self.postEventsAfterIssueSent(report: DebuggIt.sharedInstance.report)
                    self.clearData()
            }, errorBlock: { (status, error) in
                if status != nil {
                    progressPopup.dismiss(animated: true, completion:  {
                        let popup = Initializer.viewController(PopupViewController.self)
                        DebuggIt.sharedInstance.showModal(viewController: popup)
                        popup.willShowDebuggItWindow = true
                        popup.thumbImageView.image = Initializer.image(named: "thumbsDown")
                        popup.alertTextView.text = "error.send.report.badcredentials".localized()
                    })
                } else {
                    progressPopup.dismiss(animated: true, completion:  {
                        let popup = Initializer.viewController(PopupViewController.self)
                        DebuggIt.sharedInstance.showModal(viewController: popup)
                        popup.willShowDebuggItWindow = true
                        popup.thumbImageView.image = Initializer.image(named: "thumbsDown")
                        popup.alertTextView.text = "error.send.report".localized()
                    })
                }
            })
        }
    }
    
    private func postEventsAfterIssueSent(report: Report) {
        ApiClient.postEvent(.reportSent)
        ApiClient.postEvent(.audioAmount, value: report.audioUrls.count)
        ApiClient.postEvent(.screenshotAmount, value: report.screenshots.count)
        if !report.actualBehavior.isEmpty {
            ApiClient.postEvent(.actualBehaviorFilled)
        }
        if !report.stepsToReproduce.isEmpty {
            ApiClient.postEvent(.stepsToReproduceFilled)
        }
        if !report.expectedBehavior.isEmpty {
            ApiClient.postEvent(.expectedBehaviorFilled)
        }
    }
    
    private func clearData() {
        DebuggIt.sharedInstance.report = Report()
        ImageCache.shared.clearAll()
    }
    
    private func dissmissDebuggIt() {
        self.dismiss(animated: true, completion: {
            DebuggIt.sharedInstance.moveApplicationWindowToFront()
        })
    }
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: {
            DebuggIt.sharedInstance.moveApplicationWindowToFront()
        })
        ApiClient.postEvent(.reportCanceled)
        clearData()
    }
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        pageViewController.openPage(sender.currentPage)
    }

}
