//
//  Utils.swift
//  DebugIt
//
//  Created by Bartek on 08/11/16.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import Foundation

class Utils {
    
    static func convert(fromPriority: ReportPriority) -> String {
        if DebuggIt.sharedInstance.configType == .bitbucket {
            switch fromPriority {
                case .low:
                    return Constants.Bitbucket.minor
                case .medium:
                    return Constants.Bitbucket.major
                case .high:
                    return Constants.Bitbucket.critical
            }
        } else {
            return fromPriority.rawValue
        }
    }
    
}
