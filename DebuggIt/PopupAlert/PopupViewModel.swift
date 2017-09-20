//
//  PopupViewModel.swift
//  DebuggIt
//
//  Created by Mikołaj Pęcak on 20.09.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import Foundation

class PopupViewModel {
    var willShowDebuggItWindow = false
    
    func moveApplicationWindowToFront() {
        DebuggIt.sharedInstance.moveApplicationWindowToFront()
    }
    
    func showBugDescription() {
        DebuggIt.sharedInstance.showModal(viewController: Initializer.viewController(BugDescriptionViewController.self))
    }
    
    func getWillShowNextWindow() -> Bool {
        return self.willShowDebuggItWindow
    }
    
    func setWillShowNextWindow(willShow: Bool) {
        self.willShowDebuggItWindow = willShow
    }
}
