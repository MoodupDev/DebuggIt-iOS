//
//  BugDescriptionPage1ViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 02.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class BugDescriptionPage1ViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet var kindButtons: [UIButton]!
    @IBOutlet var priorityButtons: [UIButton]!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var reportItemsContainer: UIView!
    
    var reportItemsController: ReportItemsViewController!
    
    
    // MARK: - Overriden

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reportItemsController = Initializer.viewController(ReportItemsViewController.self)
        
        self.embed(reportItemsController, in: reportItemsContainer)
        
        initTitle()
        initRecordButton()
        loadDataFromReport()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    
    private func initTitle() {
        titleTextView.delegate = self
        
        titleTextView.layer.borderWidth = 1
        titleTextView.layer.borderColor = UIColor.lightGray.cgColor
        titleTextView.layer.cornerRadius = 5
        titleTextView.layer.masksToBounds = true
    }
    
    private func initRecordButton() {
        recordButton.setImage(Initializer.image(named: "recordMicroActive"), for: .selected)
        recordButton.setImage(Initializer.image(named: "recordMicroActive"), for: .highlighted)
        recordButton.setImage(Initializer.image(named: "recordMicro"), for: .normal)
    }
    
    private func loadDataFromReport() {
        let report = DebuggIt.sharedInstance.report
        if !report.title.isEmpty {
            titleTextView.text = report.title
        }
        selectFromButtons(kindButtons, title: report.kind.rawValue)
        selectFromButtons(priorityButtons, title: report.priority.rawValue)
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
    
    func reloadReportItems() {
        self.reportItemsController.collectionView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func kindSelected(_ sender: UIButton) {
        setReportKind(selectedButton: sender)
        selectFromButtons(kindButtons, selected: sender)
    }
    
    @IBAction func prioritySelected(_ sender: UIButton) {
        setReportPriority(selectedButton: sender)
        selectFromButtons(priorityButtons, selected: sender)
    }

    @IBAction func recordUploaded(segue: UIStoryboardSegue) {
        recordButton.isSelected = false
        reloadReportItems()
    }
    @IBAction func recordTapped(_ sender: UIButton) {
        if DebuggIt.sharedInstance.recordingEnabled {
            sender.isSelected = true
            let recordViewController = Initializer.viewController(RecordViewController)
            recordViewController.modalPresentationStyle = .overCurrentContext
            self.present(recordViewController, animated: true, completion: nil)
        } else {
            self.present(Utils.createAlert(title: "alert.title.recording.disabled".localized(), message: "alert.message.recording.disabled".localized(), positiveAction: {}), animated: true, completion: nil)
        }
    }
 
}

// MARK: - TextViewDelegate

extension BugDescriptionPage1ViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        DebuggIt.sharedInstance.report.title = textView.text
    }
}
