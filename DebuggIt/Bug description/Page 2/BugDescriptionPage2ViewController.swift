//
//  BugDescriptionPage2ViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 02.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class BugDescriptionPage2ViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var stepsToReproduceTextView: UITextView!
    @IBOutlet weak var actualBehaviorTextView: UITextView!
    @IBOutlet weak var expectedBehaviorTextView: UITextView!
    
    var viewModel = BugDescriptionPage2ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.stepsToReproduceTextView.delegate = self
        self.actualBehaviorTextView.delegate = self
        self.expectedBehaviorTextView.delegate = self
        
        self.loadDataFromReport()
    }

    private func loadDataFromReport() {
        self.stepsToReproduceTextView.text = self.viewModel.loadStepsToReproduceText()
        self.actualBehaviorTextView.text = self.viewModel.loadActualBehaviorText()
        self.expectedBehaviorTextView.text = self.viewModel.loadExpectedBehaviorText()
    }
}

extension BugDescriptionPage2ViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == self.stepsToReproduceTextView {
            self.viewModel.setStepsToReproduceText(text: textView.text)
        } else if textView == self.actualBehaviorTextView {
            self.viewModel.setActualBehaviorText(text: textView.text)
        } else {
            self.viewModel.setExpectedBehaviorText(text: textView.text)
        }
    }
}
