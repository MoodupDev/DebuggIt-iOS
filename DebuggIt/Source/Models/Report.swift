//
//  Report.swift
//  DebuggIt
//
//  Created by Bartek on 25/10/16.
//  Copyright © 2016 Mood Up. All rights reserved.
//

import UIKit

class Report {
    
    var title = ""
    
    var kind : ReportKind = .bug
    var priority : ReportPriority = .medium

    var stepsToReproduce = ""
    var actualBehavior = ""
    var expectedBehavior = ""
    
    var currentScreenshot: UIImage?
    var screenshotsUrls = [String]()
    var audioUrls = [String]()
    
    init() {
       
    }
}

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

