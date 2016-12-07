//
//  ReportKind.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 03.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

enum ReportKind: String {
    case bug = "Bug"
    case enhancement = "Enhancement"
    
    func name() -> String {
        if DebuggIt.sharedInstance.configType == .jira {
            switch self {
            case .enhancement:
                return Constants.Jira.task
            default:
                return self.rawValue
            }
        } else {
            return self.rawValue
        }
    }
}
