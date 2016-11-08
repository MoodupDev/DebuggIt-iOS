//
//  ScreenshotCollectionViewCell.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 08.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class ScreenshotCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var screenshotImage: UIImageView!
    weak var collectonView: UICollectionView?
    var index: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Actions
    
    @IBAction func deleteScreenshot(_ sender: UIButton) {
        if let index = index {
            DebuggIt.sharedInstance.report.screenshotsUrls.remove(at: index)
            collectonView?.reloadData()
        }
    }

}
