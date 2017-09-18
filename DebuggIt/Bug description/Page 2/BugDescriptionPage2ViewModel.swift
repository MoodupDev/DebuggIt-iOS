//
//  BugDescriptionPage2ViewModel.swift
//  DebuggIt
//
//  Created by Mikołaj Pęcak on 18.09.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import Foundation

class BugDescriptionPage2ViewModel {
    
    func getReport() -> Report {
        return DebuggIt.sharedInstance.report
    }
    
    func getStepsToReproduceText() -> String {
        let report = DebuggIt.sharedInstance.report
        if !report.stepsToReproduce.isEmpty {
            return report.stepsToReproduce
        } else {
            return ""
        }
    }
    
    func getActualBehaviorText() -> String {
        let report = DebuggIt.sharedInstance.report
        if !report.actualBehavior.isEmpty {
            return report.actualBehavior
        } else {
            return ""
        }
    }
    
    func getExpectedBehaviorText() -> String {
        let report = DebuggIt.sharedInstance.report
        if !report.expectedBehavior.isEmpty {
            return report.expectedBehavior
        } else {
            return ""
        }
    }
    
    func setStepsToReproduceText(text: String) {
        DebuggIt.sharedInstance.report.stepsToReproduce = text
    }
    
    func setActualBehaviorText(text: String) {
        DebuggIt.sharedInstance.report.actualBehavior = text
    }
    
    func setExpectedBehaviorText(text: String) {
        DebuggIt.sharedInstance.report.expectedBehavior = text
    }
}
