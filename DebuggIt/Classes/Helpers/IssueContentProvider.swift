//
//  IssueContentProvider.swift
//  Pods
//
//  Created by Arkadiusz Żmudzin on 02.12.2016.
//
//

import Foundation

class IssueContentProvider {
    
    // MARK: - Properties
    
    private static var boldMark: String {
        switch DebuggIt.sharedInstance.configType {
        case .jira:
            return "*"
        default:
            return "**"
        }
    }
    
    // MARK: Formats
    
    private static let titleFormat = "%@%@:%@ "
    private static var imageFormat: String {
        switch DebuggIt.sharedInstance.configType {
        case .jira:
            return "!%@!"
        default:
            return "![](%@)"
        }
    }
    
    // MARK: Titles
    
    private static let stepsToReproduce = "Steps to reproduce"
    private static let actualBehavior = "Actual behavior"
    private static let expectedBehavior = "Expected behavior"
    private static let priority = "Priority"
    private static let kind = "Kind"
    
    // MARK: Bolded titles
    
    private static func boldTitle(_ title: String) -> String {
        return String(format: titleFormat, boldMark, title, boldMark)
    }
    
    private static func getScreenshotLink(_ url: String) -> String {
        return String(format: imageFormat, url)
    }
    
    static func createContent(from report: Report) -> String {
        var lines = [String]()
        lines.append(boldTitle(stepsToReproduce) + report.stepsToReproduce)
        lines.append(boldTitle(actualBehavior) + report.actualBehavior)
        lines.append(boldTitle(expectedBehavior) + report.expectedBehavior)
        if DebuggIt.sharedInstance.configType == .github {
            lines.append(boldTitle(kind) + Utils.convert(fromKind: report.kind))
            lines.append(boldTitle(priority) + Utils.convert(fromPriority: report.priority))
        }
        report.screenshotsUrls.forEach { (url) in
            lines.append(getScreenshotLink(url))
        }
        report.audioUrls.forEach { (url) in
            lines.append(url)
        }
        
        return lines.reduce("", {$0 + "\n\n" + $1})
    }
}
