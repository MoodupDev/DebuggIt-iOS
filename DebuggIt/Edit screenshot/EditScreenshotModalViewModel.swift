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
            DebuggIt.sharedInstance.showModal(viewController: popup, animated: true, completion: {
                self.uploadPicture(popup, image: image)
            })
            popup.setup(willShowNextWindow: true, alertText: "alert.sending.screenshot".localized(), positiveAction: true, isProgressPopup: true)
        })
    }
    
    private func uploadPicture(_ popup: PopupViewController, image: UIImage) {
        DebuggIt.sharedInstance.storageClient?.upload(
            .image,
            data: image.toBase64String(),
            successBlock: {
                self.onUploadSuccess(popup)
            }, errorBlock: {
                (statusCode, errorMessage) in
                self.onUploadError(popup, errorCode: statusCode, errorMessage: errorMessage)
        })
    }
    
    private func onUploadError(_ popup: PopupViewController, errorCode: Int?, errorMessage: String?) {
        DispatchQueue.main.async {
            DebuggIt.sharedInstance.resetButtonImage()
            popup.dismiss(animated: true, completion: {
                DebuggIt.sharedInstance.showModal(viewController:
                    Utils.createAPIErrorAlert(
                        errorCode: errorCode,
                        errorMessage: errorMessage
                    )
                )
            })
        }
    }
    
    private func onUploadSuccess(_ popup: PopupViewController) {
        DispatchQueue.main.async {
            DebuggIt.sharedInstance.resetButtonImage()
            popup.dismiss(animated: true, completion: {
                self.showBugDescription()
            })
        }
    }
    
    func showBugDescription() {
        DebuggIt.sharedInstance.showModal(viewController: Initializer.viewController(BugDescriptionViewController.self))
    }
}
