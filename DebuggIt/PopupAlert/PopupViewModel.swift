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
}
