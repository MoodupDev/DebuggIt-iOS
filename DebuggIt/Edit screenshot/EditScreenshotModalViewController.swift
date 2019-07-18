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
        undoButton.setImage(Initializer.image(named: "iconUndoActive"), for: UIControl.State.selected)
        undoButton.setImage(Initializer.image(named: "iconUndoInactive"), for: UIControl.State.normal)
        redoButton.setImage(Initializer.image(named: "iconRedoActive"), for: UIControl.State.selected)
        redoButton.setImage(Initializer.image(named: "iconRedoInactive"), for: UIControl.State.normal)
        rectangleButton.setImage(Initializer.image(named: "iconRectangleActive"), for: UIControl.State.selected)
        rectangleButton.setImage(Initializer.image(named: "iconRectangleInactive"), for: UIControl.State.normal)
        freedrawButton.setImage(Initializer.image(named: "iconDrawActive"), for: UIControl.State.selected)
        freedrawButton.setImage(Initializer.image(named: "iconDrawInactive"), for: UIControl.State.normal)
        arrowButton.setImage(Initializer.image(named: "iconArrowActive"), for: UIControl.State.selected)
        arrowButton.setImage(Initializer.image(named: "iconArrowInactive"), for: UIControl.State.normal)
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

