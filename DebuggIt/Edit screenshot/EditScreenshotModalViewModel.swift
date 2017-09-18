//
//  EditScreenshotModalViewModel.swift
//  DebuggIt
//
//  Created by Mikołaj Pęcak on 18.09.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import Foundation

class EditScreenshotModalViewModel {
    func getCurrentScreenshot() -> UIImage? {
        return DebuggIt.sharedInstance.report.currentScreenshot
    }
    
    func moveApplicationWindowToFront() {
        DebuggIt.sharedInstance.moveApplicationWindowToFront()
    }
}
