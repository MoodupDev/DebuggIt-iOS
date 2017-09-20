//
//  PopupViewModelTests.swift
//  DebuggItTests
//
//  Created by Mikołaj Pęcak on 20.09.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import XCTest
@testable import DebuggIt

class PopupViewModelTests: XCTestCase {
    
    let viewModel = PopupViewModel()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetWillShowNextWindowDefault() {
        let result = viewModel.getWillShowNextWindow()
        XCTAssertFalse(result)
    }
    
    func testWillShowNextWindow() {
        viewModel.setWillShowNextWindow(willShow: true)
        let result = viewModel.getWillShowNextWindow()
        XCTAssertTrue(result)
    }
    
    func testWontShowNextWindow() {
        viewModel.setWillShowNextWindow(willShow: false)
        let result = viewModel.getWillShowNextWindow()
        XCTAssertFalse(result)
    }
}
