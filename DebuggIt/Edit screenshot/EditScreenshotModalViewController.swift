//
//  EditScreenshotModalViewController.swift
//  DebugIt
//
//  Created by Bartek on 27/10/16.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class EditScreenshotModalViewController: UIViewController {
    
    @IBOutlet weak var screenshotSurface: DrawingView!
    @IBOutlet weak var rectangleButton: UIButton!
    @IBOutlet weak var freedrawButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenshotSurface.image = DebuggIt.sharedInstance.report.currentScreenshot
        initButtons()
    }
    
    private func initButtons() {
        undoButton.setImage(Initializer.image(named: "undoActive" ), for: UIControlState.highlighted)
        undoButton.setImage(Initializer.image(named: "undo"), for: UIControlState.normal)
        
        rectangleButton.setImage(Initializer.image(named: "rectangleActive"), for: UIControlState.selected)
        rectangleButton.setImage(Initializer.image(named: "rectangle"), for: UIControlState.normal)
        
        freedrawButton.setImage(Initializer.image(named: "drawActive"), for: UIControlState.selected)
        freedrawButton.setImage(Initializer.image(named: "draw"), for: UIControlState.normal)
        
        freedrawButton.isSelected = true
    }
    
    @IBAction func tapDone(_ sender: UIButton) {
        screenshotSurface.pinCurrentRectangle()
        let image = screenshotSurface.image!
        
        let alertController = Utils.createAlert(title: "alert.title.sending.screenshot".localized(), message: "alert.message.wait".localized())
        present(alertController, animated: true, completion: nil)
        
        ApiClient.upload(.image, data: image.toBase64String(),
            successBlock: {
                ApiClient.postEvent(self.freedrawButton.isSelected ? .screenshotAddedDraw : .screenshotAddedRectangle)
                alertController.dismiss(animated: true, completion: self.showBugDescription)
            }, errorBlock: {
                (statusCode, errorMessage) in
                alertController.dismiss(animated: false, completion: {
                    self.present(Utils.createGeneralErrorAlert(), animated: true, completion: nil)
                })
            })
    }
    
    func showBugDescription() -> Void {
        self.dismiss(animated: true, completion: {
            DebuggIt.sharedInstance.showModal(viewController: Initializer.viewController(BugDescriptionViewController.self))
        })
    }
    
    @IBAction func tapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: {
            DebuggIt.sharedInstance.moveApplicationWindowToFront()
        })
    }
    
    @IBAction func tapUndo(_ sender: UIButton) {
        screenshotSurface.undo()
    }
    
    @IBAction func tapRectangle(_ sender: UIButton) {
        changeButtonState(sender, secondOptionButton: freedrawButton)
        screenshotSurface.type = sender.isSelected ? .rectangle : .free
    }
    
    @IBAction func tapFreeDraw(_ sender: UIButton) {
        changeButtonState(sender, secondOptionButton: rectangleButton)
        screenshotSurface.type = sender.isSelected ? .free : .rectangle
    }
    
    private func changeButtonState(_ sender:UIButton, secondOptionButton:UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            secondOptionButton.isSelected = false
        }
    }
}

