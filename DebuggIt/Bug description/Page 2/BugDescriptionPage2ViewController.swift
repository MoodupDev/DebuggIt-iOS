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
        let report = DebuggIt.sharedInstance.report
        
        if !report.stepsToReproduce.isEmpty {
            stepsToReproduceTextView.text = report.stepsToReproduce
        }
        
        if !report.actualBehavior.isEmpty {
            actualBehaviorTextView.text = report.actualBehavior
        }
        
        if !report.expectedBehavior.isEmpty {
            expectedBehaviorTextView.text = report.expectedBehavior
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension BugDescriptionPage2ViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if textView == stepsToReproduceTextView {
            DebuggIt.sharedInstance.report.stepsToReproduce = textView.text
        } else if textView == actualBehaviorTextView {
            DebuggIt.sharedInstance.report.actualBehavior = textView.text
        } else {
            DebuggIt.sharedInstance.report.expectedBehavior = textView.text
        }
    }
}
