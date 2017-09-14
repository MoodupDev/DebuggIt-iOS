//
//  BugDescriptionViewModel.swift
//  DebuggIt
//
//  Created by Mikołaj Pęcak on 14.09.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import Foundation

class BugDescriptionViewModel {
    
    var bugOptionIsActive = true
    var enhancementOptionIsActive = false
    
    func bugOptionChosen() {
        bugOptionIsActive = true
        enhancementOptionIsActive = false
    }
    
    func enhancementOptionChosen() {
        enhancementOptionIsActive = true
        bugOptionIsActive = false
    }
    
    
}
