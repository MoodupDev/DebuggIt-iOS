//
//  BugDescriptionPage1ViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 02.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class BugDescriptionPage1ViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet var kindButtons: [UIButton]!
    @IBOutlet var priorityButtons: [UIButton]!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var reportItemsStackView: UIStackView!
    
    // MARK: Overriden

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextView.delegate = self
        
        titleTextView.layer.borderWidth = 1
        titleTextView.layer.borderColor = UIColor.lightGray.cgColor
        titleTextView.layer.cornerRadius = 5
        titleTextView.layer.masksToBounds = true
        
        // TODO: add custom view for audio?
        // TODO: enable scroll in report items stack view
        for screenshot in DebuggIt.sharedInstance.report.screenshots {
            let view = UIImageView(image: screenshot)
            view.layer.cornerRadius = 5
            view.layer.masksToBounds = true
            reportItemsStackView.addArrangedSubview(view)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Methods
    
    private func deselectOtherButtons(_ buttons: [UIButton], selected: UIButton) {
        for button in buttons {
            if button != selected {
                button.isSelected = false
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func kindSelected(_ sender: UIButton) {
        sender.isSelected = true
        deselectOtherButtons(kindButtons, selected: sender)
    }
    
    @IBAction func prioritySelected(_ sender: UIButton) {
        sender.isSelected = true
        deselectOtherButtons(priorityButtons, selected: sender)
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

// MARK: TextViewDelegate

extension BugDescriptionPage1ViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        DebuggIt.sharedInstance.report.title = textView.text
        if textView.text == "" {
            textView.text = "What went wrong?"
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "What went wrong?" {
            textView.text = ""
        }
    }
}
