//
//  ReportPriority.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 03.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

enum ReportPriority: String {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    func name() -> String {
        if DebuggIt.sharedInstance.configType == .bitbucket {
            switch self {
            case .low:
                return Constants.Bitbucket.minor
            case .medium:
                return Constants.Bitbucket.major
            case .high:
                return Constants.Bitbucket.critical
            }
        } else {
            return self.rawValue
        }
    }
}
