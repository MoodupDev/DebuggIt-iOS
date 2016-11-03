//
//  ReportPriority.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 03.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

enum ReportPriority {
    case low
    case medium
    case high
    
    static func from(index: Int) -> ReportPriority {
        switch index {
        case 0:
            return .low
        case 1:
            return .medium
        default:
            return .high
        }
    }
}
