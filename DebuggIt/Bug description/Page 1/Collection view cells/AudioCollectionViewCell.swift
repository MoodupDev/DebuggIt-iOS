//
//  AudioCollectionViewCell.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 10.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioCollectionViewCellDelegate: class {
    func audioCollectionCell(_ cell: AudioCollectionViewCell, didRemoveAudioAtIndex index: Int)
}

class AudioCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    weak var delegate: AudioCollectionViewCellDelegate?
    
    var player: AVPlayer!
    
    var index: Int!
    
    // MARK: - Overriden methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        playButton.setImage(Initializer.image(named: "recordPlay"), for: .normal)
        playButton.setImage(Initializer.image(named: "recordStop"), for: .selected)
    }
    
    // MARK: - Methods
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
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
            ApiClient.postEvent(.audioPlayed)
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
        self.delegate?.audioCollectionCell(self, didRemoveAudioAtIndex: index)
    }
}
