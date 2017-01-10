//
//  BugDescriptionPage1ViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 02.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

private let screenshotReuseIdentifier = "ScreenshotCollectionViewCell"
private let newScreenshotReuseIdentifier = "NewScreenshotCollectionViewCell"
private let audioReuseIdentifier = "AudioCollectionViewCell"

class BugDescriptionPage1ViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet var kindButtons: [UIButton]!
    @IBOutlet var priorityButtons: [UIButton]!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var reportItemsCollection: UICollectionView!
    
    // MARK: - Overriden

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTitle()
        initRecordButton()
        loadDataFromReport()
        initReportItemsCollection()
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
    
    private func initReportItemsCollection() {
        self.reportItemsCollection.dataSource = self
        
        self.reportItemsCollection.register(Initializer.nib(named: screenshotReuseIdentifier), forCellWithReuseIdentifier: screenshotReuseIdentifier)
        self.reportItemsCollection.register(Initializer.nib(named: newScreenshotReuseIdentifier), forCellWithReuseIdentifier: newScreenshotReuseIdentifier)
        self.reportItemsCollection.register(Initializer.nib(named: audioReuseIdentifier), forCellWithReuseIdentifier: audioReuseIdentifier)
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
        self.reportItemsCollection.reloadData()
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

    @IBAction func recordTapped(_ sender: UIButton) {
        if DebuggIt.sharedInstance.recordingEnabled {
            sender.isSelected = true
            let recordViewController = Initializer.viewController(RecordViewController.self)
            recordViewController.delegate = self
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

// MARK: - RecordViewControllerDelegate

extension BugDescriptionPage1ViewController: RecordViewControllerDelegate {
    
    func recordUploaded() {
        recordButton.isSelected = false
        reloadReportItems()
    }
    
    func recordFailed() {
        recordButton.isSelected = false
    }
}

// MARK: - UICollectionViewDataSource

extension BugDescriptionPage1ViewController : UICollectionViewDataSource {
    
    var itemsCount: Int {
        let report = DebuggIt.sharedInstance.report
        return report.screenshots.count + report.audioUrls.count + 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == itemsCount - 1 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: newScreenshotReuseIdentifier, for: indexPath) as! NewScreenshotCollectionViewCell
        } else {
            let report = DebuggIt.sharedInstance.report
            
            if indexPath.row < report.audioUrls.count {
                return createAudioCell(for: indexPath)
            } else {
                return createScreenshotCell(for: indexPath)
            }
        }
    }
    
    func createScreenshotCell(for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = reportItemsCollection.dequeueReusableCell(withReuseIdentifier: screenshotReuseIdentifier, for: indexPath) as! ScreenshotCollectionViewCell
        
        let report = DebuggIt.sharedInstance.report
        let screenshots = report.screenshots
        let index = indexPath.row - report.audioUrls.count
        if let url = URL(string: screenshots[index].url) {
            cell.screenshotImage.loadFrom(url: url)
        }
        cell.index = index
        
        return cell
    }
    
    func createAudioCell(for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = reportItemsCollection.dequeueReusableCell(withReuseIdentifier: audioReuseIdentifier, for: indexPath) as! AudioCollectionViewCell
        cell.index = indexPath.row
        cell.label.text = String(format: "audio.label".localized(), indexPath.row + 1)
        return cell
    }
}
