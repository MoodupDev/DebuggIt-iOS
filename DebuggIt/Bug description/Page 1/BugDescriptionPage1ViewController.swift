//
//  BugDescriptionPage1ViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 02.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

protocol BugDescriptionPage1Delegate: class {
    func bugDescriptionPageOneDidClickAddNewScreenshot(_ viewController: BugDescriptionPage1ViewController)
}

class BugDescriptionPage1ViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel = BugDescriptionPage1ViewModel()
    @IBOutlet var kindButtons: [UIButton]!
    @IBOutlet var priorityButtons: [UIButton]!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var reportItemsCollection: UICollectionView!
    weak var delegate: BugDescriptionPage1Delegate?
    // MARK: - Overriden

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTitle()
        initRecordButton()
        loadDataFromReport()
        initReportItemsCollection()
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
        titleTextView.text = self.viewModel.loadReportTitle()
        selectFromButtons(kindButtons, title: self.viewModel.loadReportKind())
        selectFromButtons(priorityButtons, title: self.viewModel.loadReportPriority())
    }
    
    private func initReportItemsCollection() {
        self.reportItemsCollection.dataSource = self
        
        self.reportItemsCollection.register(Initializer.nib(named: Constants.screenshotReuseIdentifier), forCellWithReuseIdentifier: Constants.screenshotReuseIdentifier)
        self.reportItemsCollection.register(Initializer.nib(named: Constants.newScreenshotReuseIdentifier), forCellWithReuseIdentifier: Constants.newScreenshotReuseIdentifier)
        self.reportItemsCollection.register(Initializer.nib(named: Constants.audioReuseIdentifier), forCellWithReuseIdentifier: Constants.audioReuseIdentifier)
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
                if let kind = ReportKind(rawValue: (button.titleLabel?.text)!) {
                    self.viewModel.setReportKind(selected: kind)
                }
            }
        }
    }
    
    private func setReportPriority(selectedButton: UIButton) {
        for (_, button) in priorityButtons.enumerated() {
            if(button == selectedButton) {
                if let priority = ReportPriority(rawValue: (button.titleLabel?.text)!) {
                    self.viewModel.setReportPriority(selected: priority)
                }
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
        if self.viewModel.isRecordingEnabled() {
            sender.isSelected = true
            let recordViewController = Initializer.viewController(RecordViewController.self)
            recordViewController.delegate = self
            recordViewController.modalPresentationStyle = .overCurrentContext
            self.present(recordViewController, animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: {
                let popup = Initializer.viewController(PopupViewController.self)
                DebuggIt.sharedInstance.showModal(viewController: popup)
                popup.setup(willShowNextWindow: true, alertText: "alert.message.recording.disabled".localized(), positiveAction: false, isProgressPopup: false)
            })
        }
    }
}

// MARK: - TextViewDelegate

extension BugDescriptionPage1ViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.setTitle(text: textView.text)
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
        return self.viewModel.getScreenshotCount()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == itemsCount - 1 {
            guard let screenShotCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.newScreenshotReuseIdentifier, for: indexPath) as? NewScreenshotCollectionViewCell else { return UICollectionViewCell() }
            screenShotCell.delegate = self
            
            return screenShotCell
        } else {
            if indexPath.row < self.viewModel.getAudioUrlCount() {
                return createAudioCell(for: indexPath)
            } else {
                return createScreenshotCell(for: indexPath)
            }
        }
    }
    
    func createScreenshotCell(for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = reportItemsCollection.dequeueReusableCell(withReuseIdentifier: Constants.screenshotReuseIdentifier, for: indexPath) as! ScreenshotCollectionViewCell
        let screenshots = self.viewModel.loadScreenshots()
        let index = indexPath.row - self.viewModel.getAudioUrlCount()
        if let url = URL(string: screenshots[index].url) {
            cell.screenshotImage.loadFrom(url: url)
        }
        cell.index = index
        cell.delegate = self
        
        return cell
    }
    
    func createAudioCell(for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = reportItemsCollection.dequeueReusableCell(withReuseIdentifier: Constants.audioReuseIdentifier, for: indexPath) as! AudioCollectionViewCell
        cell.index = indexPath.row
        cell.label.text = String(format: "audio.label".localized(), indexPath.row + 1)
        cell.delegate = self
        return cell
    }
}

extension BugDescriptionPage1ViewController: AudioCollectionViewCellDelegate {
    func audioCollectionCell(_ cell: AudioCollectionViewCell, didRemoveAudioAtIndex index: Int) {
        DebuggIt.sharedInstance.report.audioUrls.remove(at: index)
        ApiClient.postEvent(.audioRemoved)
        self.reportItemsCollection.reloadData()
    }
}

extension BugDescriptionPage1ViewController: NewScreenshotCollectionViewCellDelegate {
    func newScreenshotCellDidClickAddNewScreenshot(_ cell: NewScreenshotCollectionViewCell) {
        self.delegate?.bugDescriptionPageOneDidClickAddNewScreenshot(self)
    }
}

extension BugDescriptionPage1ViewController: ScreenshotCollectionViewCellDelegate {
    func screenshotCollectionViewCell(_ cell: ScreenshotCollectionViewCell, didRemoveScreenshotAtIndex index: Int) {
        let screenshot = DebuggIt.sharedInstance.report.screenshots.remove(at: index)
        ImageCache.shared.clear(key: screenshot.url)
        ApiClient.postEvent(.screenshotRemoved)
        self.reportItemsCollection.reloadData()
    }
}
