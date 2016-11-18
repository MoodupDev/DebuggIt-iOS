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
    var index: Int?
    
    // MARK: - Actions
    
    @IBAction func deleteScreenshot(_ sender: UIButton) {
        if let index = index {
            DebuggIt.sharedInstance.report.screenshotsUrls.remove(at: index)
            if let viewController = self.viewController() as? ReportItemsViewController {
                viewController.collectionView.reloadData()
            }
        }
    }

}
