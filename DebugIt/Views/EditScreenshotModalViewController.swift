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
        //todo go to the form modal
        present(UIStoryboard.init(name: "Report", bundle: nil).instantiateViewController(withIdentifier: "BugDescription"), animated: true, completion: nil)
    }
    
    @IBAction func tapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapUndo(_ sender: UIButton) {
        screenshotSurface.image = DebuggIt.sharedInstance.report.screenshots.last
    }
    
    @IBAction func tapRectangle(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if(sender.isSelected) {
            freedrawButton.isSelected = false
        }
    }
    
    @IBAction func tapFreeDraw(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if(sender.isSelected) {
            rectangleButton.isSelected = false
        }
        
        screenshotSurface.active(isActive: sender.isSelected)
    }
}

