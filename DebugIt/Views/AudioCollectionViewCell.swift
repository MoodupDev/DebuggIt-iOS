//
//  AudioCollectionViewCell.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 10.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class AudioCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var playButton: UIButton!
    
    var index: Int!
    
    // MARK: - Overriden methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Actions
    @IBAction func playAudio(_ sender: UIButton) {
        // TODO: implement playing audio
    }
    
    @IBAction func removeAudio(_ sender: UIButton) {
        DebuggIt.sharedInstance.report.audioUrls.remove(at: index)
        if let viewController = self.viewController() as? ReportItemsViewController {
            viewController.collectionView.reloadData()
        }
    }

}
