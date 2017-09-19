//
//  BugDescriptionViewModelTests.swift
//  DebuggItTests
//
//  Created by Mikołaj Pęcak on 19.09.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import XCTest
@testable import DebuggIt

class BugDescriptionViewModelTests: XCTestCase {
    
    let bugDescriptionViewModel = BugDescriptionViewModel()
    let bugDescriptionPage1ViewModel = BugDescriptionPage1ViewModel()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        DebuggIt.sharedInstance.report = Report()
        ImageCache.shared.clearAll()
    }
    
    func testIsTitleEmptyDefault() {
        let result = bugDescriptionViewModel.isTitleEmpty()
        XCTAssertTrue(result)
    }
    
    func testIsTitleEmpty() {
        bugDescriptionPage1ViewModel.setTitle(text: "Some title")
        let result = bugDescriptionViewModel.isTitleEmpty()
        XCTAssertFalse(result)
    }
    
    func testTitleCharactersCount() {
        bugDescriptionPage1ViewModel.setTitle(text: "Some title")
        let result = bugDescriptionViewModel.getTitleCharactersCount()
        XCTAssertEqual(result, 10)
    }
    
    func testTitleCharactersCountIfEmpty() {
        let result = bugDescriptionViewModel.getTitleCharactersCount()
        XCTAssertEqual(result, 0)
    }
    
    func testClearData() {
        bugDescriptionPage1ViewModel.setReportKind(selected: .enhancement)
        bugDescriptionPage1ViewModel.setReportPriority(selected: .high)
        bugDescriptionPage1ViewModel.setTitle(text: "Important title!")
        bugDescriptionViewModel.clearData()
        let kind = bugDescriptionPage1ViewModel.loadReportKind()
        let priority = bugDescriptionPage1ViewModel.loadReportPriority()
        let title = bugDescriptionPage1ViewModel.loadReportTitle()
        XCTAssertEqual(kind, "Bug")
        XCTAssertEqual(priority, "Medium")
        XCTAssertEqual(title, "")
    }
}
