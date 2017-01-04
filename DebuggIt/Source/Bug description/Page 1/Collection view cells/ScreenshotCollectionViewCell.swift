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
            let screenshot = DebuggIt.sharedInstance.report.screenshots.remove(at: index)
            ImageCache.shared.clear(key: screenshot.url)
            ApiClient.postEvent(.screenshotRemoved)
            if let viewController = self.viewController() as? BugDescriptionPage1ViewController {
                viewController.reportItemsCollection.reloadData()
            }
        }
    }

}
