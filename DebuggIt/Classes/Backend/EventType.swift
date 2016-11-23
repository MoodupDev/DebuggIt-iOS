//
//  EventType.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 04.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import Foundation

enum EventType : String {
    case initialized
    case hasUnsupportedVersion
    case screenshotAddedRectangle
    case screenshotAddedDraw
    case screenshotRemoved
    case screenshotAmount
    case audioAdded
    case audioRecordTime
    case audioPlayed
    case audioRemoved
    case audioAmount
    case reportSent
    case reportCanceled
    case stepsToReproduceFilled
    case actualBehaviorFilled
    case expectedBehaciorFilled
    case appCrashed
    
    func name() -> String {
        var name: String
        do {
            let regex = try NSRegularExpression(pattern: "([a-z])([A-Z])", options: .init(rawValue: 0))
            name = regex.stringByReplacingMatches(in: self.rawValue, options: .init(rawValue: 0), range: NSMakeRange(0, self.rawValue.characters.count), withTemplate: "$1 $2")
            name = name.lowercased().replacingOccurrences(of: " ", with: "_")
        } catch {
            name = ""
        }
        return name
    }
}
