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
    var lowPriorityOptionIsActive = false
    var mediumPriorityOptionIsActive = true
    var highPriorityOptionIsActive = false
    
    func bugOptionChosen() {
        bugOptionIsActive = true
        enhancementOptionIsActive = false
    }
    
    func enhancementOptionChosen() {
        enhancementOptionIsActive = true
        bugOptionIsActive = false
    }
    
    func lowPriorityOptionChosen() {
        lowPriorityOptionIsActive = true
        mediumPriorityOptionIsActive = false
        highPriorityOptionIsActive = false
    }
    
    func mediumPriorityOptionChosen() {
        mediumPriorityOptionIsActive = true
        lowPriorityOptionIsActive = false
        highPriorityOptionIsActive = false
    }
    
    func highPriorityOptionChosen() {
        highPriorityOptionIsActive = true
        lowPriorityOptionIsActive = false
        mediumPriorityOptionIsActive = false
    }
    
    
    
}
