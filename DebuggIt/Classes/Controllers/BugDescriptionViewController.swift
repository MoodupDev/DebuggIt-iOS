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
        self.present(Utils.createAlert(title: "alert.title.send.report".localized(), message: "Do you want to send the report?", positiveAction: self.sendReport, negativeAction: {}), animated: true, completion: nil)
    }
    
    private func sendReport() {
        if DebuggIt.sharedInstance.report.title.isEmpty {
            present(Utils.createAlert(title: "alert.title.failure".localized(), message: "error.title.empty".localized(), positiveAction: {}), animated: true, completion: nil)
        } else {
            let alertController = Utils.createAlert(title: "alert.title.sending.report".localized(), message: "alert.message.wait".localized())
            present(alertController, animated: true, completion: nil)
            
            DebuggIt.sharedInstance.sendReport(
                successBlock: {
                    alertController.dismiss(animated: false, completion: {
                        self.present(Utils.createAlert(title: "alert.title.success".localized(), message: "alert.message.saved.report".localized(), positiveAction: self.dissmissDebuggIt, negativeAction: nil), animated: true, completion: nil)
                    })
                    self.postEventsAfterIssueSent(report: DebuggIt.sharedInstance.report)
                    DebuggIt.sharedInstance.report = Report()
            }, errorBlock: {
                (status, error) in
                alertController.dismiss(animated: false, completion:  {
                    self.present(Utils.createAlert(title: "alert.title.failure".localized(), message: Utils.parseError(error), positiveAction: {}, negativeAction: nil), animated: true, completion: nil)
                })
            })
        }
    }
    
    private func postEventsAfterIssueSent(report: Report) {
        ApiClient.postEvent(.reportSent)
        ApiClient.postEvent(.audioAmount, value: report.audioUrls.count)
        ApiClient.postEvent(.screenshotAmount, value: report.screenshotsUrls.count)
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
        DebuggIt.sharedInstance.report = Report()
    }
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        pageViewController.openPage(sender.currentPage)
    }

}
