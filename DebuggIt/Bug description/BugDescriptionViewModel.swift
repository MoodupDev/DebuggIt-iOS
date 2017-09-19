//
//  BugDescriptionViewModel.swift
//  DebuggIt
//
//  Created by Mikołaj Pęcak on 18.09.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import Foundation

class BugDescriptionViewModel {
    
    func isTitleEmpty() -> Bool {
        let title = DebuggIt.sharedInstance.report.title
        if title.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func getTitleCharactersCount() -> Int {
        return DebuggIt.sharedInstance.report.title.characters.count
    }
    
    func clearData() {
        DebuggIt.sharedInstance.report = Report()
        ImageCache.shared.clearAll()
    }
    
    func moveApplicationWindowToFront() {
        DebuggIt.sharedInstance.moveApplicationWindowToFront()
    }
}
