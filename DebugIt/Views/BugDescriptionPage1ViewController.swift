//
//  BugDescriptionPage1ViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 02.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit
import Nuke

class BugDescriptionPage1ViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet var kindButtons: [UIButton]!
    @IBOutlet var priorityButtons: [UIButton]!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var reportItemsStackView: UIStackView!
    @IBOutlet weak var recordButton: UIButton!
    
    
    // MARK: Overriden

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTitle()
        initRecordButton()
        loadDataFromReport()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Methods
    
    private func initTitle() {
        titleTextView.delegate = self
        
        titleTextView.layer.borderWidth = 1
        titleTextView.layer.borderColor = UIColor.lightGray.cgColor
        titleTextView.layer.cornerRadius = 5
        titleTextView.layer.masksToBounds = true
    }
    
    private func initRecordButton() {
        recordButton.setImage(UIImage(named: "recordMicroActive"), for: .selected)
        recordButton.setImage(UIImage(named: "recordMicroActive"), for: .highlighted)
        recordButton.setImage(UIImage(named: "recordMicro"), for: .normal)
    }
    
    private func loadDataFromReport() {
        let report = DebuggIt.sharedInstance.report
        if !report.title.isEmpty {
            titleTextView.text = report.title
        }
        selectFromButtons(kindButtons, title: report.kind.rawValue)
        selectFromButtons(priorityButtons, title: report.priority.rawValue)
        // TODO: add custom view for audio?
        // TODO: enable scroll in report items stack view
        loadScreenshots()
    }
    
    private func loadScreenshots() {
        for screenshot in DebuggIt.sharedInstance.report.screenshotsUrls {
            let view = UIImageView()
            Nuke.loadImage(with: URL(string: screenshot)!, into: view)
            view.layer.cornerRadius = 5
            view.layer.masksToBounds = true
            view.contentMode = UIViewContentMode.scaleAspectFit
            reportItemsStackView.addArrangedSubview(view)
        }
    }
    
    private func selectFromButtons(_ buttons: [UIButton], selected: UIButton) {
        for button in buttons {
            button.isSelected = button == selected
        }
    }
    
    private func selectFromButtons(_ buttons: [UIButton], title: String) {
        for (_, button) in buttons.enumerated() {
            button.isSelected = button.titleLabel?.text == title
        }
    }

    
    private func setReportKind(selectedButton: UIButton) {
        for (_, button) in kindButtons.enumerated() {
            if(button == selectedButton) {
                DebuggIt.sharedInstance.report.kind = ReportKind(rawValue: (button.titleLabel?.text)!)!
            }
        }
    }
    
    private func setReportPriority(selectedButton: UIButton) {
        for (_, button) in priorityButtons.enumerated() {
            if(button == selectedButton) {
                DebuggIt.sharedInstance.report.priority = ReportPriority(rawValue: (button.titleLabel?.text)!)!
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func kindSelected(_ sender: UIButton) {
        setReportKind(selectedButton: sender)
        selectFromButtons(kindButtons, selected: sender)
    }
    
    @IBAction func prioritySelected(_ sender: UIButton) {
        setReportPriority(selectedButton: sender)
        selectFromButtons(priorityButtons, selected: sender)
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
