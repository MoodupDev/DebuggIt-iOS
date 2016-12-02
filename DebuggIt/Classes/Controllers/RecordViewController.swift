//
//  RecordViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 09.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, DebuggItViewControllerProtocol {
    
    // MARK: - Properties
    
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var recordCircle: UIImageView!
    
    var remainingTime: Int = 60
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var timer = Timer()
    
    var audioFilename: URL!
    
    var delegate: RecordViewControllerDelegate?
    
    // MARK: - Overriden methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RecordViewController.updateUi), userInfo: nil, repeats: true)
                        self.startRecording()
                    } else {
                        delegate?.recordFailed()
                    }
                }
            }
        } catch {
            delegate?.recordFailed()
        }
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
                self.present(alert, animated: true, completion: nil)
                ApiClient.upload(.audio, data: fileData.base64EncodedString(), successBlock: {
                    alert.dismiss(animated: true, completion: nil)
                    self.present(Utils.createAlert(title: "alert.title.send.audio".localized(), message: "alert.message.saved.audio".localized(), positiveAction: {
                        self.dismiss(animated: true, completion: nil)
                        self.delegate?.recordUploaded()
                    }), animated: true, completion: nil)
                }, errorBlock: { (code, message) in
                    alert.dismiss(animated: true, completion: nil)
                    self.present(Utils.createAlert(title: "alert.title.send.audio".localized(), message: "error.general".localized(), positiveAction: {}), animated: true, completion: nil)
                })
            }
        } else {
            delegate?.recordFailed()
        }
    }
    
    
    func updateUi() {
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
