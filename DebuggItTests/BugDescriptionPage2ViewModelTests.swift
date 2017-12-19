//
//  BugDescriptionPage2ViewModelTests.swift
//  DebuggItTests
//
//  Created by Mikołaj Pęcak on 19.09.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import XCTest
@testable import DebuggIt

class BugDescriptionPage2ViewModelTests: XCTestCase {
    
    let viewModel = BugDescriptionPage2ViewModel()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        DebuggIt.sharedInstance.report = Report()
        ImageCache.shared.clearAll()
    }
    
    func testStepsToReproduceDefaultEmpty() {
        let result = viewModel.loadStepsToReproduceText()
        XCTAssertEqual(result, "")
    }
    
    func testActualBehaviorDefaultEmpty() {
        let result = viewModel.loadActualBehaviorText()
        XCTAssertEqual(result, "")
    }
    
    func testExpectedBehaviorDefaultEmpty() {
        let result = viewModel.loadExpectedBehaviorText()
        XCTAssertEqual(result, "")
    }
    
    func testStepsToReproduce() {
        viewModel.setStepsToReproduceText(text: "Some string")
        let result = viewModel.loadStepsToReproduceText()
        XCTAssertEqual(result, "Some string")
    }
    
    func testActualBehavior() {
        viewModel.setActualBehaviorText(text: "Actual Behavior string")
        let result = viewModel.loadActualBehaviorText()
        XCTAssertEqual(result, "Actual Behavior string")
    }
    
    func testExpectedBehavior() {
        viewModel.setExpectedBehaviorText(text: "Expected Behavior text")
        let result = viewModel.loadExpectedBehaviorText()
        XCTAssertEqual(result, "Expected Behavior text")
    }
    
}
