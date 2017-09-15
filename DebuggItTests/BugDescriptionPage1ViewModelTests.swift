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
    
    func testInitialBugOptionIsActiveAndOtherAreInactive() {
        let result = self.bugDescriptionViewModel.reportType.rawValue
        XCTAssertEqual(result, "bug")
    }
    
    func testBugOptionIsChosen() {
        self.bugDescriptionViewModel.bugOptionChosen()
        let result = self.bugDescriptionViewModel.reportType.rawValue
        XCTAssertEqual(result, "bug")
    }
    
    func testEnhancementOptionIsChosen() {
        self.bugDescriptionViewModel.enhancementOptionChosen()
        let result = self.bugDescriptionViewModel.reportType.rawValue
        XCTAssertEqual(result, "enhancement")
    }
    
    func testBugOptionIsChosenAfterSwitchingFromAnother() {
        self.bugDescriptionViewModel.enhancementOptionChosen()
        self.bugDescriptionViewModel.bugOptionChosen()
        let result = self.bugDescriptionViewModel.reportType.rawValue
        XCTAssertEqual(result, "bug")
    }
    
    func testEnhancementOptionIsChosenAfterSwitchingFromAnother() {
        self.bugDescriptionViewModel.bugOptionChosen()
        self.bugDescriptionViewModel.enhancementOptionChosen()
        let result = self.bugDescriptionViewModel.reportType.rawValue
        XCTAssertEqual(result, "enhancement")
    }
    
    func testInitialMediumPriorityOptionActiveAndOtherInactive() {
        let result = self.bugDescriptionViewModel.priority.rawValue
        XCTAssertEqual(result, "medium")
    }
    
    func testLowPriorityOptionChosen() {
        self.bugDescriptionViewModel.lowPriorityOptionChosen()
        let result = self.bugDescriptionViewModel.priority.rawValue
        XCTAssertEqual(result, "low")
    }
    
    func testMediumPriorityOptionChosen() {
        self.bugDescriptionViewModel.mediumPriorityOptionChosen()
        let result = self.bugDescriptionViewModel.priority.rawValue
        XCTAssertEqual(result, "medium")
    }
    
    func testHighPriorityOptionChosen() {
        self.bugDescriptionViewModel.highPriorityOptionChosen()
        let result = self.bugDescriptionViewModel.priority.rawValue
        XCTAssertEqual(result, "high")
    }
    
    func testLowPriorityIsChosenAfterSwitchingFromAnother() {
        self.bugDescriptionViewModel.mediumPriorityOptionChosen()
        self.bugDescriptionViewModel.lowPriorityOptionChosen()
        let result = self.bugDescriptionViewModel.priority.rawValue
        XCTAssertEqual(result, "low")
    }
    
    func testMediumPriorityIsChosenAfterSwitchingFromAnother() {
        self.bugDescriptionViewModel.lowPriorityOptionChosen()
        self.bugDescriptionViewModel.mediumPriorityOptionChosen()
        let result = self.bugDescriptionViewModel.priority.rawValue
        XCTAssertEqual(result, "medium")
    }
    
    func testHighPriorityIsChosenAfterSwitchingFromAnother() {
        self.bugDescriptionViewModel.lowPriorityOptionChosen()
        self.bugDescriptionViewModel.highPriorityOptionChosen()
        let result = self.bugDescriptionViewModel.priority.rawValue
        XCTAssertEqual(result, "high")
    }
    
    func testWriteTitle() {
        let titleString = "New title"
        self.bugDescriptionViewModel.writeTitle(text: titleString)
        let result = self.bugDescriptionViewModel.title
        XCTAssertEqual(result, titleString)
    }

}
