//
//  ScreenshotCollectionViewCell.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 08.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

protocol ScreenshotCollectionViewCellDelegate: class {
    func screenshotCollectionViewCell(_ cell: ScreenshotCollectionViewCell, didRemoveScreenshotAtIndex index: Int)
}

class ScreenshotCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var screenshotImage: UIImageView!
    weak var delegate: ScreenshotCollectionViewCellDelegate?
    var index: Int?
    
    // MARK: - Actions
    
    @IBAction func deleteScreenshot(_ sender: UIButton) {
        if let index = index {
            self.delegate?.screenshotCollectionViewCell(self, didRemoveScreenshotAtIndex: index)
        }
    }

}
