//
//  AudioCollectionViewCell.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 10.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit
import AVFoundation

class AudioCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var playButton: UIButton!
    
    var player: AVPlayer!
    
    var index: Int!
    
    // MARK: - Overriden methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        playButton.setImage(Initializer.image(named: "recordPlay"), for: .normal)
        playButton.setImage(Initializer.image(named: "recordStop"), for: .selected)
    }
    
    // MARK: - Methods
    
    func playerDidFinishPlaying(note: NSNotification) {
        finishPlaying()
    }
    
    private func finishPlaying() {
        playButton.isSelected = false
        player = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    private func startPlaying() {
        if let url = URL(string: DebuggIt.sharedInstance.report.audioUrls[index]) {
            let playerItem = AVPlayerItem(url: url)
            
            NotificationCenter.default.addObserver(self, selector: #selector(AudioCollectionViewCell.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
            
            self.player = AVPlayer(playerItem:playerItem)
            player!.volume = 1.0
            player!.play()
            playButton.isSelected = true
        }
    }
    
    // MARK: - Actions
    @IBAction func togglePlayAudio(_ sender: UIButton) {
        if sender.isSelected {
            finishPlaying()
        } else {
            startPlaying()
        }
    }
    
    @IBAction func removeAudio(_ sender: UIButton) {
        DebuggIt.sharedInstance.report.audioUrls.remove(at: index)
        if let viewController = self.viewController() as? BugDescriptionPage1ViewController {
            viewController.reportItemsCollection.reloadData()
        }
    }

}
