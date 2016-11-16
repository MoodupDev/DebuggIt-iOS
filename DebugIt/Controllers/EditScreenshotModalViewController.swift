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
    
    var currentRectangle:ResizableRectangle?
    var rectangles = [ResizableRectangle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenshotSurface.image = DebuggIt.sharedInstance.report.screenshots.last
        initButtons()
    }
    
    private func initButtons() {
        undoButton.setImage(UIImage.init(named: "undoActive"), for: UIControlState.highlighted)
        undoButton.setImage(UIImage.init(named: "undo"), for: UIControlState.normal)
        
        rectangleButton.setImage(UIImage.init(named: "rectangleActive"), for: UIControlState.selected)
        rectangleButton.setImage(UIImage.init(named: "rectangle"), for: UIControlState.normal)
        
        freedrawButton.setImage(UIImage.init(named: "drawActive"), for: UIControlState.selected)
        freedrawButton.setImage(UIImage.init(named: "draw"), for: UIControlState.normal)
        
        freedrawButton.isSelected = true
    }
    
    @IBAction func tapDone(_ sender: UIButton) {
        if currentRectangle != nil {
            finishWithRectangle()
        }
        UIGraphicsBeginImageContext(containerView.bounds.size)
        containerView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        DebuggIt.sharedInstance.report.screenshots.removeLast()
        DebuggIt.sharedInstance.report.screenshots.append(image)
        
        UIGraphicsEndImageContext()
        
        let alertController = Utils.createLoadingAlert(title: "Sending screenshot", message: "Wait for the end...")
        present(alertController, animated: true, completion: nil)
        
        ApiClient.upload(.image, data: image.toBase64String(),
            successBlock: {
                ApiClient.postEvent(self.freedrawButton.isSelected ? .screenshotAddedDraw : .screenshotAddedRectangle)
                alertController.dismiss(animated: true, completion: self.handleAlertDismissal(viewController: self))
            }, errorBlock: {
                (statusCode, errorMessage) in
                alertController.dismiss(animated: false, completion: nil)
            })
    }
    
    private func handleAlertDismissal(viewController: UIViewController) -> (() -> Void) {
        func dismissAlert() -> Void {
            viewController.dismiss(animated: true, completion: {
                let bugDescriptionViewController = UIStoryboard.init(name: Constants.Storyboards.report, bundle: nil).instantiateViewController(withIdentifier: Constants.ViewControllers.bugDescription) as! BugDescriptionViewController
                UIApplication.shared.keyWindow?.rootViewController?.present(bugDescriptionViewController, animated: true, completion: nil)
            })
        }
        
        return dismissAlert
    }
    
    @IBAction func tapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapUndo(_ sender: UIButton) {
        screenshotSurface.image = DebuggIt.sharedInstance.report.screenshots.last
        for view in containerView.subviews {
            if view != screenshotSurface {
                view.removeFromSuperview()
            }
        }
    }
    
    @IBAction func tapRectangle(_ sender: UIButton) {
        changeButtonState(sender, secondOptionButton: freedrawButton)
        screenshotSurface.active(isActive: !sender.isSelected)
        
        if currentRectangle != nil {
            finishWithRectangle()
        }
        
        if(sender.isSelected) {
            currentRectangle = ResizableRectangle.instantiateFromNib()
            
            currentRectangle?.center.y = screenshotSurface.center.y
            currentRectangle?.center.x = screenshotSurface.center.x
            
            currentRectangle?.backgroundView.layer.borderColor = UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha:1.0).cgColor
            currentRectangle?.backgroundView.layer.borderWidth = 5.0
            
            containerView.addSubview(currentRectangle!)
        } else {
            finishWithRectangle()
        }
    }
    
    @IBAction func tapFreeDraw(_ sender: UIButton) {
        changeButtonState(sender, secondOptionButton: rectangleButton)
        screenshotSurface.active(isActive: sender.isSelected)
        finishWithRectangle()
    }
    
    private func finishWithRectangle() {
        currentRectangle?.pin()
        if currentRectangle != nil {
            rectangles.append(currentRectangle!)
        }
    }
    
    private func changeButtonState(_ sender:UIButton, secondOptionButton:UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            secondOptionButton.isSelected = false
        }
    }
}
