//
//  NewScreenshotCollectionViewCell.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 09.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol NewScreenshotDelegate: NSObjectProtocol {
    func changeDebuggItButtonImage()
}

class NewScreenshotCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: NewScreenshotDelegate?
    
    // MARK: - Actions
    
    @IBAction func addNewScreenshot(_ sender: UIButton) {
        self.delegate = DebuggIt.sharedInstance

        self.viewController()?.presentingViewController?.dismiss(animated: true, completion: {
            DebuggIt.sharedInstance.moveApplicationWindowToFront()
            self.delegate?.changeDebuggItButtonImage()
        })
        IQKeyboardManager.sharedManager().enable = false
    }

}
