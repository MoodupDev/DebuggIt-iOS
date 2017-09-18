//
//  WelcomeViewModel.swift
//  DebuggIt
//
//  Created by Mikołaj Pęcak on 18.09.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import Foundation

class WelcomeViewModel {
    func moveApplicationWindowToFront() {
        DebuggIt.sharedInstance.moveApplicationWindowToFront()
    }
    
    func welcomeScreenHasBeenShown() {
        DebuggIt.sharedInstance.welcomeScreenHasBeenShown = true
    }
}
