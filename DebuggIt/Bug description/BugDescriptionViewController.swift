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
                self.showPopup(willShowNextWindow: true, alertText: "error.title.empty".localized(), positiveAction: false, isProgressPopup: false)
            })
        } else if title.characters.count > titleMaxCharacters {
            self.dismiss(animated: true, completion: {
                let popup = Initializer.viewController(PopupViewController.self)
                DebuggIt.sharedInstance.showModal(viewController: popup)
                self.showPopup(willShowNextWindow: true, alertText: "error.title.too.long".localized(), positiveAction: false, isProgressPopup: false)
            })
        } else {
            let progressPopup = Initializer.viewController(PopupViewController.self)
            self.dismiss(animated: true, completion: {
                DebuggIt.sharedInstance.showModal(viewController: progressPopup)
                progressPopup.setup(willShowNextWindow: true, alertText: "alert.sending.report".localized(), positiveAction: true, isProgressPopup: true)
            })
            
            DebuggIt.sharedInstance.sendReport(
                successBlock: {
                    progressPopup.dismiss(animated: true, completion: {
                        self.showPopup(willShowNextWindow: false, alertText: "alert.message.saved.report".localized(), positiveAction: true, isProgressPopup: false)
                    })
                    self.postEventsAfterIssueSent(report: DebuggIt.sharedInstance.report)
                    self.clearData()
            }, errorBlock: { (status, error) in
                if status != nil {
                    progressPopup.dismiss(animated: true, completion:  {
                        self.showPopup(willShowNextWindow: true, alertText: "error.send.report.badcredentials".localized(), positiveAction: false, isProgressPopup: false)
                    })
                } else {
                    progressPopup.dismiss(animated: true, completion:  {
                        self.showPopup(willShowNextWindow: true, alertText: "error.send.report".localized(), positiveAction: false, isProgressPopup: false)
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
    
    func showPopup(willShowNextWindow: Bool, alertText: String, positiveAction: Bool, isProgressPopup: Bool) {
        let popup = Initializer.viewController(PopupViewController.self)
        DebuggIt.sharedInstance.showModal(viewController: popup)
        popup.setup(willShowNextWindow: willShowNextWindow, alertText: alertText, positiveAction: positiveAction, isProgressPopup: isProgressPopup)
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
