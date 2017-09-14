//
//  BugDescriptionPage1Tests.swift
//  DebuggItTests
//
//  Created by Mikołaj Pęcak on 14.09.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import XCTest
@testable import DebuggIt

class BugDescriptionPage1Tests: XCTestCase {
    
    let bugDescriptionViewModel = BugDescriptionViewModel()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialBugOptionIsActiveAndOtherAreInactive() {
        let bugOption = self.bugDescriptionViewModel.bugOptionIsActive
        let enhancementOption = self.bugDescriptionViewModel.enhancementOptionIsActive
        XCTAssertTrue(bugOption)
        XCTAssertFalse(enhancementOption)
    }
    
    func testBugOptionIsChosen() {
        self.bugDescriptionViewModel.bugOptionChosen()
        let bugOption = self.bugDescriptionViewModel.bugOptionIsActive
        let enhancementOption = self.bugDescriptionViewModel.enhancementOptionIsActive
        XCTAssertTrue(bugOption)
        XCTAssertFalse(enhancementOption)
    }
    
    func testEnhancementOptionIsChosen() {
        self.bugDescriptionViewModel.enhancementOptionChosen()
        let enhancementOption = self.bugDescriptionViewModel.enhancementOptionIsActive
        let bugOption = self.bugDescriptionViewModel.bugOptionIsActive
        XCTAssertTrue(enhancementOption)
        XCTAssertFalse(bugOption)
    }
    
    func testBugOptionIsChosenAfterSwitchingFromAnother() {
        self.bugDescriptionViewModel.enhancementOptionChosen()
        self.bugDescriptionViewModel.bugOptionChosen()
        let bugOption = self.bugDescriptionViewModel.bugOptionIsActive
        let enhancementOption = self.bugDescriptionViewModel.enhancementOptionIsActive
        XCTAssertTrue(bugOption)
        XCTAssertFalse(enhancementOption)
    }
    
    func testEnhancementOptionIsChosenAfterSwitchingFromAnother() {
        self.bugDescriptionViewModel.bugOptionChosen()
        self.bugDescriptionViewModel.enhancementOptionChosen()
        let bugOption = self.bugDescriptionViewModel.bugOptionIsActive
        let enhancementOption = self.bugDescriptionViewModel.enhancementOptionIsActive
        XCTAssertTrue(enhancementOption)
        XCTAssertFalse(bugOption)
    }
    
    func testInitialMediumPriorityOptionActiveAndOtherInactive() {
        let lowPriorityOption = self.bugDescriptionViewModel.lowPriorityOptionIsActive
        let mediumPriorityOption = self.bugDescriptionViewModel.mediumPriorityOptionIsActive
        let highPriorityOption = self.bugDescriptionViewModel.highPriorityOptionIsActive
        XCTAssertTrue(mediumPriorityOption)
        XCTAssertFalse(lowPriorityOption)
        XCTAssertFalse(highPriorityOption)
    }
    
    func testLowPriorityOptionChosen() {
        self.bugDescriptionViewModel.lowPriorityOptionChosen()
        let lowPriorityOption = self.bugDescriptionViewModel.lowPriorityOptionIsActive
        let mediumPriorityOption = self.bugDescriptionViewModel.mediumPriorityOptionIsActive
        let highPriorityOption = self.bugDescriptionViewModel.highPriorityOptionIsActive
        XCTAssertTrue(lowPriorityOption)
        XCTAssertFalse(mediumPriorityOption)
        XCTAssertFalse(highPriorityOption)
    }
    
    func testMediumPriorityOptionChosen() {
        self.bugDescriptionViewModel.mediumPriorityOptionChosen()
        let lowPriorityOption = self.bugDescriptionViewModel.lowPriorityOptionIsActive
        let mediumPriorityOption = self.bugDescriptionViewModel.mediumPriorityOptionIsActive
        let highPriorityOption = self.bugDescriptionViewModel.highPriorityOptionIsActive
        XCTAssertTrue(mediumPriorityOption)
        XCTAssertFalse(lowPriorityOption)
        XCTAssertFalse(highPriorityOption)
    }
    
    func testHighPriorityOptionChosen() {
        self.bugDescriptionViewModel.highPriorityOptionChosen()
        let lowPriorityOption = self.bugDescriptionViewModel.lowPriorityOptionIsActive
        let mediumPriorityOption = self.bugDescriptionViewModel.mediumPriorityOptionIsActive
        let highPriorityOption = self.bugDescriptionViewModel.highPriorityOptionIsActive
        XCTAssertTrue(highPriorityOption)
        XCTAssertFalse(lowPriorityOption)
        XCTAssertFalse(mediumPriorityOption)
    }
    
    func testLowPriorityIsChosenAfterSwitchingFromAnother() {
        self.bugDescriptionViewModel.mediumPriorityOptionChosen()
        self.bugDescriptionViewModel.lowPriorityOptionChosen()
        let lowPriorityOption = self.bugDescriptionViewModel.lowPriorityOptionIsActive
        let mediumPriorityOption = self.bugDescriptionViewModel.mediumPriorityOptionIsActive
        let highPriorityOption = self.bugDescriptionViewModel.highPriorityOptionIsActive
        XCTAssertTrue(lowPriorityOption)
        XCTAssertFalse(mediumPriorityOption)
        XCTAssertFalse(highPriorityOption)
    }
    
    func testMediumPriorityIsChosenAfterSwitchingFromAnother() {
        self.bugDescriptionViewModel.lowPriorityOptionChosen()
        self.bugDescriptionViewModel.mediumPriorityOptionChosen()
        let lowPriorityOption = self.bugDescriptionViewModel.lowPriorityOptionIsActive
        let mediumPriorityOption = self.bugDescriptionViewModel.mediumPriorityOptionIsActive
        let highPriorityOption = self.bugDescriptionViewModel.highPriorityOptionIsActive
        XCTAssertTrue(mediumPriorityOption)
        XCTAssertFalse(lowPriorityOption)
        XCTAssertFalse(highPriorityOption)
    }
    
    func testHighPriorityIsChosenAfterSwitchingFromAnother() {
        self.bugDescriptionViewModel.lowPriorityOptionChosen()
        self.bugDescriptionViewModel.highPriorityOptionChosen()
        let lowPriorityOption = self.bugDescriptionViewModel.lowPriorityOptionIsActive
        let mediumPriorityOption = self.bugDescriptionViewModel.mediumPriorityOptionIsActive
        let highPriorityOption = self.bugDescriptionViewModel.highPriorityOptionIsActive
        XCTAssertTrue(highPriorityOption)
        XCTAssertFalse(lowPriorityOption)
        XCTAssertFalse(mediumPriorityOption)
    }

}
