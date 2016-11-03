//
//  ReportKind.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 03.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

enum ReportKind {
    case bug
    case enhancement
    
    static func from(index: Int) -> ReportKind {
        switch index {
        case 0:
            return .bug
        default:
            return .enhancement
        }
    }
}
