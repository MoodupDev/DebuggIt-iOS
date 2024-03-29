//
//  RecordViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 09.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var recordCircle: UIImageView!
    
    var remainingTime: Int = 60
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var timer = Timer()
    
    var audioFilename: URL!
    
    var delegate: RecordViewControllerDelegate?
    var applicationIdleTimerDisabled: Bool = false
    
    // MARK: - Overriden methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.applicationIdleTimerDisabled = UIApplication.shared.isIdleTimerDisabled
        UIApplication.shared.isIdleTimerDisabled = true

        // Do any additional setup after loading the view.
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSession.Category.playAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RecordViewController.updateUi), userInfo: nil, repeats: true)
                        self.startRecording()
                    } else {
                        self.delegate?.recordFailed()
                    }
                }
            }
        } catch {
            delegate?.recordFailed()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        UIApplication.shared.isIdleTimerDisabled = self.applicationIdleTimerDisabled
    }

    // MARK: - Methods
    
    private func startRecording() {
        audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename!, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
        } catch {
            finishRecording(success: false)
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func finishRecording(success: Bool) {
        if audioRecorder != nil {
            audioRecorder.stop()
            audioRecorder = nil
        }
        
        if success {
            if let fileData = FileManager().contents(atPath: audioFilename!.relativePath) {
                let alert = Utils.createAlert(title: "alert.title.sending.audio".localized(), message: "alert.message.wait".localized())
                self.present(alert, animated: true, completion: {
                    self.uploadAudio(alert, data: fileData.base64EncodedString())
                })
            }
        } else {
            delegate?.recordFailed()
        }
    }
    
    private func uploadAudio(_ alert: UIAlertController, data: String) {
        DebuggIt.sharedInstance.storageClient?.upload(.audio, data: data, successBlock: {
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: nil)
                self.showAudioSentDialog()
            }
        }, errorBlock: { (code, message) in
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: {
                    self.present(Utils.createGeneralErrorAlert(action: {
                        self.delegate?.recordFailed()
                        self.dismiss(animated: true, completion: nil)
                    }), animated: true, completion: nil)
                })
            }
        })
    }
    
    private func showAudioSentDialog() {
        self.present(
            Utils.createAlert(
                title: "alert.title.send.audio".localized(),
                message: "alert.message.saved.audio".localized(),
                positiveAction: {
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.recordUploaded()
                }
            ),
            animated: true,
            completion: nil
        )
    }
    
    @objc func updateUi() {
        remainingTime -= 1
        remainingTimeLabel.text = String(format: "00:%02d", remainingTime)
        recordCircle.alpha = CGFloat(remainingTime % 2)
        if remainingTime == 0 {
            stopRecording()
        }
    }
    
    private func stopRecording() {
        timer.invalidate()
        finishRecording(success: true)
    }
    
    // MARK: - Actions
    
    @IBAction func recordStopped(_ sender: UIButton) {
        stopRecording()
    }
}

// MARK: - AVAudioRecorderDelegate

extension RecordViewController : AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}

// MARK: - RecordViewControllerDelegate

protocol RecordViewControllerDelegate {
    func recordUploaded()
    func recordFailed()
}
