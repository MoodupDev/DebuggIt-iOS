//
//  BugDescriptionPage1ViewModel.swift
//  DebuggIt
//
//  Created by Mikołaj Pęcak on 14.09.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import Foundation

class BugDescriptionPage1ViewModel {
    
    func getReport() -> Report {
        return DebuggIt.sharedInstance.report
    }
    
    func loadReportTitle() -> String {
        let title = DebuggIt.sharedInstance.report.title
        if !title.isEmpty {
            return title
        }
        return ""
    }
    
    func loadReportKind() -> String {
        return DebuggIt.sharedInstance.report.kind.rawValue
    }
    
    func getAudioUrlCount() -> Int {
        return DebuggIt.sharedInstance.report.audioUrls.count
    }
    
    func getScreenshotCount() -> Int {
        let report = DebuggIt.sharedInstance.report
        return report.screenshots.count + report.audioUrls.count + 1
    }
    
    func loadScreenshots() -> [Screenshot] {
        return DebuggIt.sharedInstance.report.screenshots
    }
    
    func loadReportPriority() -> String {
        return DebuggIt.sharedInstance.report.priority.rawValue
    }
    
    func setReportKind(selected: ReportKind) {
        DebuggIt.sharedInstance.report.kind = selected
    }
    
    func setReportPriority(selected: ReportPriority) {
        DebuggIt.sharedInstance.report.priority = selected
    }

//    func bugOptionChosen() {
//        self.reportType = .bug
//    }
//
//    func enhancementOptionChosen() {
//        self.reportType = .enhancement
//    }
//
//    func lowPriorityOptionChosen() {
//        self.priority = .low
//    }
//
//    func mediumPriorityOptionChosen() {
//        self.priority = .medium
//    }
//
//    func highPriorityOptionChosen() {
//        self.priority = .high
//    }

    func setTitle(text: String) {
        DebuggIt.sharedInstance.report.title = text
    }
    
    func isRecordingEnabled() -> Bool {
        return DebuggIt.sharedInstance.recordingEnabled
    }
}
