//
//  Config.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 13.01.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import Foundation

class Config: NSObject {
    static let sharedInstance = Config()
    
    var configs: NSDictionary!
    
    override init() {
        let currentConfiguration = Initializer.bundle(forClass: Config.self).object(forInfoDictionaryKey: "Config") as! String
        
        let path = Initializer.bundle(forClass: Config.self).path(forResource: "Config", ofType: "plist")!
        configs = NSDictionary(contentsOfFile: path)!.object(forKey: currentConfiguration) as! NSDictionary
    }
}

extension Config {
    func apiBaseUrl() -> String {
        return configs.object(forKey: "API_BASE_URL") as! String
    }
}
