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
    
    var currentRectangle:ResizableRectangle?
    
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
        UIGraphicsBeginImageContext(screenshotSurface.bounds.size)
        screenshotSurface.draw(screenshotSurface.layer, in: UIGraphicsGetCurrentContext()!)
        DebuggIt.sharedInstance.report.screenshots.removeLast()
        DebuggIt.sharedInstance.report.screenshots.append(UIGraphicsGetImageFromCurrentImageContext()!)
        UIGraphicsEndImageContext()
        
        present(UIStoryboard.init(name: "Report", bundle: nil).instantiateViewController(withIdentifier: "BugDescription"), animated: true, completion: nil)
    }
    
    @IBAction func tapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapUndo(_ sender: UIButton) {
        screenshotSurface.image = DebuggIt.sharedInstance.report.screenshots.last
        for view in screenshotSurface.subviews {
            view.removeFromSuperview()
        }
    }
    
    @IBAction func tapRectangle(_ sender: UIButton) {
        changeButtonState(sender, secondOptionButton: freedrawButton)
        screenshotSurface.active(isActive: !sender.isSelected)
        
        if(sender.isSelected) {
            currentRectangle = ResizableRectangle.instantiateFromNib()
            
            currentRectangle?.center.y = screenshotSurface.center.y
            currentRectangle?.center.x = screenshotSurface.center.x
            
            currentRectangle?.layer.borderColor = UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha:1.0).cgColor
            currentRectangle?.layer.borderWidth = 5.0
            
            screenshotSurface.addSubview(currentRectangle!)
        } else {
            currentRectangle?.pin()
        }
    }
    
    @IBAction func tapFreeDraw(_ sender: UIButton) {
        changeButtonState(sender, secondOptionButton: rectangleButton)
        screenshotSurface.active(isActive: sender.isSelected)
        currentRectangle?.pin()
    }
    
    private func changeButtonState(_ sender:UIButton, secondOptionButton:UIButton) {
        sender.isSelected = !sender.isSelected
        
        if(sender.isSelected) {
            secondOptionButton.isSelected = false
        }
        
    }
}

