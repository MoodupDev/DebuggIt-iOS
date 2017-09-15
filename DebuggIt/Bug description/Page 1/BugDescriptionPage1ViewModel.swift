//
//  BugDescriptionPage1ViewModel.swift
//  DebuggIt
//
//  Created by Mikołaj Pęcak on 14.09.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import Foundation

class BugDescriptionPage1ViewModel {
    
    let report = DebuggIt.sharedInstance.report
    var title = ""
    var reportType: ReportKind!
    var priority: ReportPriority!
    
    init() {
        reportType = report.kind
        priority = report.priority
    }
    
    func loadDataFromReport() -> String {
        if !report.title.isEmpty {
            self.title = report.title
        }
        return self.title
    }
    
    func loadKindButtons() -> String {
        return report.kind.rawValue
    }
    
    func loadPriorityButtons() -> String {
        return report.priority.rawValue
    }

    func bugOptionChosen() {
        self.reportType = .bug
    }

    func enhancementOptionChosen() {
        self.reportType = .enhancement
    }

    func lowPriorityOptionChosen() {
        self.priority = .low
    }

    func mediumPriorityOptionChosen() {
        self.priority = .medium
    }

    func highPriorityOptionChosen() {
        self.priority = .high
    }

    func writeTitle(text: String) {
        self.title = text
    }
}
