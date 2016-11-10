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
                        print("failed to record!")
                    }
                }
            }
        } catch {
            print("catch: failed to record!")
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
                let alert = Utils.createLoadingAlert(title: "Uploading audio", message: "Wait for end...")
                self.present(alert, animated: true, completion: nil)
                ApiClient.upload(.audio, data: fileData.base64EncodedString(), successBlock: {
                    alert.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "recordUploaded", sender: self)
                }, errorBlock: { (code, message) in
                    alert.dismiss(animated: true, completion: nil)
                    // TODO: show error message 
                })
            }
        } else {
            print("finishRecording: failed to record!")
        }
    }
    
    
    private func updateUi() {
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
