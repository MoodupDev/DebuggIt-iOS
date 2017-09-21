//
//  EditScreenshotModalViewController.swift
//  DebugIt
//
//  Created by Bartek on 27/10/16.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class EditScreenshotModalViewController: UIViewController, DrawingViewDelegate {
    
    @IBOutlet weak var screenshotSurface: DrawingView!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var rectangleButton: UIButton!
    @IBOutlet weak var freedrawButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    var viewModel = EditScreenshotModalViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenshotSurface.image = self.viewModel.getCurrentScreenshot()
        self.initButtons()
        self.screenshotSurface.delegate = self
    }
    
    private func initButtons() {
        undoButton.setImage(Initializer.image(named: "iconUndoActive"), for: UIControlState.selected)
        undoButton.setImage(Initializer.image(named: "iconUndoInactive"), for: UIControlState.normal)
        redoButton.setImage(Initializer.image(named: "iconRedoActive"), for: UIControlState.selected)
        redoButton.setImage(Initializer.image(named: "iconRedoInactive"), for: UIControlState.normal)
        rectangleButton.setImage(Initializer.image(named: "iconRectangleActive"), for: UIControlState.selected)
        rectangleButton.setImage(Initializer.image(named: "iconRectangleInactive"), for: UIControlState.normal)
        freedrawButton.setImage(Initializer.image(named: "iconDrawActive"), for: UIControlState.selected)
        freedrawButton.setImage(Initializer.image(named: "iconDrawInactive"), for: UIControlState.normal)
        arrowButton.setImage(Initializer.image(named: "iconArrowActive"), for: UIControlState.selected)
        arrowButton.setImage(Initializer.image(named: "iconArrowInactive"), for: UIControlState.normal)
        arrowButton.isSelected = true
    }
    
    @IBAction func tapDone(_ sender: UIButton) {
        self.screenshotSurface.pinCurrentRectangle()
        if let image = screenshotSurface.image {
            self.viewModel.editScreenshotDone(self, image: image)
        }
    }
    
    @IBAction func tapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: {
            self.viewModel.moveApplicationWindowToFront()
        })
    }
    
    @IBAction func tapUndo(_ sender: UIButton) {
        self.screenshotSurface.undo()
    }
    
    @IBAction func tapRedo(_ sender: UIButton) {
        self.screenshotSurface.redo()
    }
    
    @IBAction func tapArrow(_ sender: UIButton) {
        changeButtonState(sender, secondOptionButton: freedrawButton, thirdOptionButton: rectangleButton)
        self.screenshotSurface.type = .arrow
    }
    
    @IBAction func tapRectangle(_ sender: UIButton) {
        changeButtonState(sender, secondOptionButton: freedrawButton, thirdOptionButton: arrowButton)
        self.screenshotSurface.type = .rectangle
    }
    
    @IBAction func tapFreeDraw(_ sender: UIButton) {
        changeButtonState(sender, secondOptionButton: rectangleButton, thirdOptionButton: arrowButton)
        self.screenshotSurface.type = .free
    }
    
    private func changeButtonState(_ sender: UIButton, secondOptionButton: UIButton, thirdOptionButton: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            secondOptionButton.isSelected = false
            thirdOptionButton.isSelected = false
        }
    }
    
    func highlightUndoButton(highlight: Bool) {
        if highlight {
            undoButton.isSelected = true
        } else {
            undoButton.isSelected = false
        }
    }
    
    func highlightRedoButton(highlight: Bool) {
        if highlight {
            redoButton.isSelected = true
        } else {
            redoButton.isSelected = false
        }
    }
}

