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
    
    let viewModel = BugDescriptionPage1ViewModel()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testWriteTitle() {
        DebuggIt.sharedInstance.report.title = "New title"
        let result = self.viewModel.loadReportTitle()
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
        self.viewModel.setReportKind(selected: .enhancement)
        let result = DebuggIt.sharedInstance.report.kind.rawValue
        XCTAssertEqual(result, "Enhancement")
    }
    
    func testChooseBugOption() {
        self.viewModel.setReportKind(selected: .enhancement)
        self.viewModel.setReportKind(selected: .bug)
        let result = DebuggIt.sharedInstance.report.kind.rawValue
        XCTAssertEqual(result, "Bug")
    }
    
    func testChooseLowPriorityOption() {
        self.viewModel.setReportPriority(selected: .low)
        let result = DebuggIt.sharedInstance.report.priority.rawValue
        XCTAssertEqual(result, "Low")
    }
    
    func testChooseHighPriorityOption() {
        self.viewModel.setReportPriority(selected: .high)
        let result = DebuggIt.sharedInstance.report.priority.rawValue
        XCTAssertEqual(result, "High")
    }
    
    func testChooseMediumPriorityOption() {
        self.viewModel.setReportPriority(selected: .low)
        self.viewModel.setReportPriority(selected: .medium)
        let result = DebuggIt.sharedInstance.report.priority.rawValue
        XCTAssertEqual(result, "Medium")
    }
    
    func testIsRecordingEnabled() {
        DebuggIt.sharedInstance.recordingEnabled = true
        XCTAssertTrue(self.viewModel.isRecordingEnabled())
    }
    
    func testIsRecordingDisabled() {
        DebuggIt.sharedInstance.recordingEnabled = false
        XCTAssertFalse(self.viewModel.isRecordingEnabled())
    }
}
