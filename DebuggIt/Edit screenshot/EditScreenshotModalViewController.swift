//
//  EditScreenshotModalViewController.swift
//  DebugIt
//
//  Created by Bartek on 27/10/16.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class EditScreenshotModalViewController: UIViewController, DrawingViewDelegate {
    
    @IBOutlet weak var backgroundView: BackgroundView!
    @IBOutlet weak var surfaceContainer: UIView!
    
    @IBOutlet weak var screenshotSurface: DrawingView!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var rectangleButton: UIButton!
    @IBOutlet weak var freedrawButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var controlButtonsStackView: UIStackView!
    @IBOutlet weak var navigationStackView: UIStackView!
    
    var viewModel = EditScreenshotModalViewModel()
    
    var landscapeConstraints: [NSLayoutConstraint] = []
    var portraitConstraints: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenshotSurface.image = self.viewModel.getCurrentScreenshot()
        self.initButtons()
        self.screenshotSurface.delegate = self
        self.adjustViewToOrientation()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.adjustViewToOrientation()
    }
    
    private func adjustViewToOrientation() {
        guard let screenshotSurface = self.screenshotSurface,
            let surfaceContainer = self.surfaceContainer,
            let controlStackView = self.controlButtonsStackView,
            let navigationStackView = self.navigationStackView else { return }
        
        let isPortrait = UIDevice.current.orientation.isFlat ? (self.view.frame.height > self.view.frame.width) : UIDevice.current.orientation.isPortrait
        
        if isPortrait {
            let containerWidth = UIScreen.main.bounds.width - 50 - 16
            let containerHeight = UIScreen.main.bounds.height - 48 - 80 - 32
            
            landscapeConstraints.forEach { backgroundView.removeConstraint($0) }
            landscapeConstraints.removeAll()
            
            portraitConstraints.append(NSLayoutConstraint(item: surfaceContainer, attribute: .leading, relatedBy: .equal, toItem: backgroundView, attribute: .leading, multiplier: 1.0, constant: 8.0))
            portraitConstraints.append(NSLayoutConstraint(item: surfaceContainer, attribute: .bottom, relatedBy: .equal, toItem: controlStackView, attribute: .top, multiplier: 1.0, constant: -8.0))
            portraitConstraints.append(NSLayoutConstraint(item: controlStackView, attribute: .trailing, relatedBy: .equal, toItem: backgroundView, attribute: .trailing, multiplier: 1.0, constant: -8.0))
            portraitConstraints.append(NSLayoutConstraint(item: controlStackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0))
            portraitConstraints.append(NSLayoutConstraint(item: screenshotSurface, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenshotSurface.getWidth(containerWidth: containerWidth, containerHeight: containerHeight)))
            portraitConstraints.append(NSLayoutConstraint(item: screenshotSurface, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenshotSurface.getHeight(containerWidth: containerWidth, containerHeight: containerHeight)))
            
            controlStackView.axis = .horizontal
            
            portraitConstraints.forEach { backgroundView.addConstraint($0) }
        } else {
            let containerWidth = UIScreen.main.bounds.width - 50 - 40 - 24
            let containerHeight = UIScreen.main.bounds.height - 48 - 40 - 24
            
            portraitConstraints.forEach { backgroundView.removeConstraint($0) }
            portraitConstraints.removeAll()
            
            landscapeConstraints.append(NSLayoutConstraint(item: surfaceContainer, attribute: .leading, relatedBy: .equal, toItem: controlStackView, attribute: .trailing, multiplier: 1.0, constant: 8.0))
            landscapeConstraints.append(NSLayoutConstraint(item: surfaceContainer, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1.0, constant: -8.0))
            landscapeConstraints.append(NSLayoutConstraint(item: controlStackView, attribute: .top, relatedBy: .equal, toItem: navigationStackView, attribute: .bottom, multiplier: 1.0, constant: 8.0))
            landscapeConstraints.append(NSLayoutConstraint(item: controlStackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0))
            landscapeConstraints.append(NSLayoutConstraint(item: screenshotSurface, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenshotSurface.getWidth(containerWidth: containerWidth, containerHeight: containerHeight)))
            landscapeConstraints.append(NSLayoutConstraint(item: screenshotSurface, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenshotSurface.getHeight(containerWidth: containerWidth, containerHeight: containerHeight)))
            
            controlStackView.axis = .vertical
            
            landscapeConstraints.forEach { backgroundView.addConstraint($0) }
        }
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

