//
//  NewScreenshotCollectionViewCell.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 09.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class NewScreenshotCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Actions
    
    @IBAction func addNewScreenshot(_ sender: UIButton) {
        self.viewController()?.presentingViewController?.dismiss(animated: true, completion: nil)
        DebuggIt.sharedInstance.moveApplicationWindowToFront()
        IQKeyboardManager.sharedManager().enable = false
    }

}
