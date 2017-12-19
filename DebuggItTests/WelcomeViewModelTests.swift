//
//  WelcomeViewModelTests.swift
//  DebuggItTests
//
//  Created by Mikołaj Pęcak on 19.09.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import XCTest
@testable import DebuggIt

class WelcomeViewModelTests: XCTestCase {
    
    let viewModel = WelcomeViewModel()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testWelcomeScreenHasBeenShown() {
        viewModel.welcomeScreenHasBeenShown()
        XCTAssertTrue(DebuggIt.sharedInstance.welcomeScreenHasBeenShown)
    }
}
