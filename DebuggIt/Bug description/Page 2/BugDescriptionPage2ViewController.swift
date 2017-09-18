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
        stepsToReproduceTextView.delegate = self
        actualBehaviorTextView.delegate = self
        expectedBehaviorTextView.delegate = self
        
        loadDataFromReport()
    }

    private func loadDataFromReport() {
        stepsToReproduceTextView.text = viewModel.getStepsToReproduceText()
        actualBehaviorTextView.text = viewModel.getActualBehaviorText()
        expectedBehaviorTextView.text = viewModel.getExpectedBehaviorText()
    }
}

extension BugDescriptionPage2ViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == stepsToReproduceTextView {
            viewModel.setStepsToReproduceText(text: textView.text)
        } else if textView == actualBehaviorTextView {
            viewModel.setActualBehaviorText(text: textView.text)
        } else {
            viewModel.setExpectedBehaviorText(text: textView.text)
        }
    }
}
