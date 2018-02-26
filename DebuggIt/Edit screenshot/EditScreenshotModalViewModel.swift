//
//  EditScreenshotModalViewModel.swift
//  DebuggIt
//
//  Created by Mikołaj Pęcak on 18.09.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import Foundation

class EditScreenshotModalViewModel {
    func getCurrentScreenshot() -> UIImage? {
        return DebuggIt.sharedInstance.report.currentScreenshot
    }
    
    func moveApplicationWindowToFront() {
        DebuggIt.sharedInstance.moveApplicationWindowToFront()
    }
    
    func editScreenshotDone(_ viewController: EditScreenshotModalViewController, image: UIImage) {
        let popup = Initializer.viewController(PopupViewController.self)
        viewController.dismiss(animated: true, completion: {
            DebuggIt.sharedInstance.showModal(viewController: popup)
            popup.setup(willShowNextWindow: true, alertText: "alert.sending.screenshot".localized(), positiveAction: true, isProgressPopup: true)
        })
        
        ApiClient.upload(.image, data: image.toBase64String(),
                         successBlock: {
                            ApiClient.postEvent(viewController.freedrawButton.isSelected ? .screenshotAddedDraw : .screenshotAddedRectangle)
                            popup.dismiss(animated: true, completion: self.showBugDescription)
        }, errorBlock: {
            (statusCode, errorMessage) in
            popup.dismiss(animated: false, completion: {
                viewController.present(Utils.createGeneralErrorAlert(), animated: true, completion: nil)
            })
        })
    }
    
    func showBugDescription() {
        DebuggIt.sharedInstance.showModal(viewController: Initializer.viewController(BugDescriptionViewController.self))
    }
}