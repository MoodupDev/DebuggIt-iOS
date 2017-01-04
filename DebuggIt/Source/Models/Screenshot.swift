//
//  Screenshot.swift
//  Pods
//
//  Created by Arkadiusz Żmudzin on 04.01.2017.
//
//

import Foundation

class Screenshot {
    
    // MARK: - Properties
    
    var url: String = ""
    var screenName: String = ""
 
    init(screenName: String, url: String) {
        self.screenName = screenName
        self.url = url
    }
}
