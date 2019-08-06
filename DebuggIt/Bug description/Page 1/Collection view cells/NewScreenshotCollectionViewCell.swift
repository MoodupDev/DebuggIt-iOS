//
//  NewScreenshotCollectionViewCell.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 09.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol NewScreenshotCollectionViewCellDelegate: NSObjectProtocol {
    func newScreenshotCellDidClickAddNewScreenshot(_ cell: NewScreenshotCollectionViewCell)
}

class NewScreenshotCollectionViewCell: UICollectionViewCell {
    weak var delegate: NewScreenshotCollectionViewCellDelegate?
    
    // MARK: - Actions
    @IBAction func addNewScreenshot(_ sender: UIButton) {
//        self.delegate = DebuggIt.sharedInstance
        self.delegate?.newScreenshotCellDidClickAddNewScreenshot(self)

    }

}
