//
//  BugDescriptionViewModel.swift
//  DebuggIt
//
//  Created by Mikołaj Pęcak on 18.09.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import Foundation

class BugDescriptionViewModel {
    
    func isTitleEmpty() -> Bool {
        let title = DebuggIt.sharedInstance.report.title
        if title.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func getTitleCharactersCount() -> Int {
        return DebuggIt.sharedInstance.report.title.characters.count
    }
    
    func clearData() {
        ApiClient.postEvent(.reportCanceled)
        DebuggIt.sharedInstance.report = Report()
        ImageCache.shared.clearAll()
    }
    
    func moveApplicationWindowToFront() {
        DebuggIt.sharedInstance.moveApplicationWindowToFront()
    }
    
    func sendReport(viewController: BugDescriptionViewController) {
        if self.isTitleEmpty() {
            self.showEmptyTitlePopup(viewController)
        } else if self.getTitleCharactersCount() > Constants.reportTitleMaxCharacters {
            self.showTooLongTitlePopup(viewController)
        } else {
            self.trySendReport(viewController)
        }
    }
    
    func showEmptyTitlePopup(_ viewController: BugDescriptionViewController) {
        viewController.dismiss(animated: true, completion: {
            self.showPopup(willShowNextWindow: true, alertText: "error.title.empty".localized(), positiveAction: false, isProgressPopup: false)
        })
    }
    
    func showTooLongTitlePopup(_ viewController: BugDescriptionViewController) {
        viewController.dismiss(animated: true, completion: {
            let title = String(format: "error.title.too.long".localized(), Constants.reportTitleMaxCharacters, DebuggIt.sharedInstance.report.title.characters.count)
            self.showPopup(willShowNextWindow: true, alertText: title, positiveAction: false, isProgressPopup: false)
        })
    }
    
    func trySendReport(_ viewController: BugDescriptionViewController) {
        let progressPopup = Initializer.viewController(PopupViewController.self)
        viewController.dismiss(animated: true, completion: {
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
    
    func postEventsAfterIssueSent(report: Report) {
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
    
    func showPopup(willShowNextWindow: Bool, alertText: String, positiveAction: Bool, isProgressPopup: Bool) {
        let popup = Initializer.viewController(PopupViewController.self)
        DebuggIt.sharedInstance.showModal(viewController: popup)
        popup.setup(willShowNextWindow: willShowNextWindow, alertText: alertText, positiveAction: positiveAction, isProgressPopup: isProgressPopup)
    }
}
