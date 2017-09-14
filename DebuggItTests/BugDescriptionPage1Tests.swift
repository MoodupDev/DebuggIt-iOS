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
    
    func testInitialBugOptionIsActive() {
        let result = self.bugDescriptionViewModel.bugOptionIsActive
        XCTAssertTrue(result)
    }
    
    func testInitialEnhancementOptionIsInactive() {
        let result = self.bugDescriptionViewModel.enhancementOptionIsActive
        XCTAssertFalse(result)
    }
    
    func testBugOptionIsChosen() {
        self.bugDescriptionViewModel.bugOptionChosen()
        let result = self.bugDescriptionViewModel.bugOptionIsActive
        XCTAssertTrue(result)
    }
    
    func testEnhancementIsInactiveWhenBugIsChosen() {
        self.bugDescriptionViewModel.bugOptionChosen()
        let result = self.bugDescriptionViewModel.enhancementOptionIsActive
        XCTAssertFalse(result)
    }
    
    func testEnhancementOptionIsChosen() {
        self.bugDescriptionViewModel.enhancementOptionChosen()
        let result = self.bugDescriptionViewModel.enhancementOptionIsActive
        XCTAssertTrue(result)
    }
    
    func testBugIsInactiveWhenEnhancementIsChosen() {
        self.bugDescriptionViewModel.enhancementOptionChosen()
        let result = self.bugDescriptionViewModel.bugOptionIsActive
        XCTAssertFalse(result)
    }
    
    func testBugActivityAfterSwitchingFromEnhancementToBugOption() {
        self.bugDescriptionViewModel.enhancementOptionChosen()
        self.bugDescriptionViewModel.bugOptionChosen()
        let result = self.bugDescriptionViewModel.bugOptionIsActive
        XCTAssertTrue(result)
    }
    
    func testEnhancementActivityAfterSwitchingFromEnhancementToBugOption() {
        self.bugDescriptionViewModel.enhancementOptionChosen()
        self.bugDescriptionViewModel.bugOptionChosen()
        let result = self.bugDescriptionViewModel.enhancementOptionIsActive
        XCTAssertFalse(result)
    }
    
    func testBugAtivityAfterSwitchingFromBugToEnhancementOption() {
        self.bugDescriptionViewModel.bugOptionChosen()
        self.bugDescriptionViewModel.enhancementOptionChosen()
        let result = self.bugDescriptionViewModel.bugOptionIsActive
        XCTAssertFalse(result)
    }
    
    func testEnhancementActivityAfterSwitchingFromBugToEnhancementOption() {
        self.bugDescriptionViewModel.bugOptionChosen()
        self.bugDescriptionViewModel.enhancementOptionChosen()
        let result = self.bugDescriptionViewModel.enhancementOptionIsActive
        XCTAssertTrue(result)
    }
    
}
