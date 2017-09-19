//
//  BugDescriptionPage1ViewModelTests.swift
//  DebuggItTests
//
//  Created by Mikołaj Pęcak on 14.09.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import XCTest
@testable import DebuggIt

class BugDescriptionPage1ViewModelTests: XCTestCase {
    
    let bugDescriptionViewModel = BugDescriptionPage1ViewModel()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testWriteTitle() {
        DebuggIt.sharedInstance.report.title = "New title"
        let result = self.bugDescriptionViewModel.loadReportTitle()
        XCTAssertEqual(result, "New title")
    }
    
    func testBugOptionDefaultActive() {
        let result = DebuggIt.sharedInstance.report.kind.rawValue
        XCTAssertEqual(result, "Bug")
    }
    
    func testMediumPriorityDefaultActive() {
        let result = DebuggIt.sharedInstance.report.priority.rawValue
        XCTAssertEqual(result, "Medium")
    }
    
    func testChooseEnhancementOption() {
        self.bugDescriptionViewModel.setReportKind(selected: .enhancement)
        let result = DebuggIt.sharedInstance.report.kind.rawValue
        XCTAssertEqual(result, "Enhancement")
    }
    
    func testChooseBugOption() {
        self.bugDescriptionViewModel.setReportKind(selected: .enhancement)
        self.bugDescriptionViewModel.setReportKind(selected: .bug)
        let result = DebuggIt.sharedInstance.report.kind.rawValue
        XCTAssertEqual(result, "Bug")
    }
    
    func testChooseLowPriorityOption() {
        self.bugDescriptionViewModel.setReportPriority(selected: .low)
        let result = DebuggIt.sharedInstance.report.priority.rawValue
        XCTAssertEqual(result, "Low")
    }
    
    func testChooseHighPriorityOption() {
        self.bugDescriptionViewModel.setReportPriority(selected: .high)
        let result = DebuggIt.sharedInstance.report.priority.rawValue
        XCTAssertEqual(result, "High")
    }
    
    func testChooseMediumPriorityOption() {
        self.bugDescriptionViewModel.setReportPriority(selected: .low)
        self.bugDescriptionViewModel.setReportPriority(selected: .medium)
        let result = DebuggIt.sharedInstance.report.priority.rawValue
        XCTAssertEqual(result, "Medium")
    }
    
    func testIsRecordingEnabled() {
        DebuggIt.sharedInstance.recordingEnabled = true
        XCTAssertTrue(self.bugDescriptionViewModel.isRecordingEnabled())
    }
    
    func testIsRecordingDisabled() {
        DebuggIt.sharedInstance.recordingEnabled = false
        XCTAssertFalse(self.bugDescriptionViewModel.isRecordingEnabled())
    }
}
