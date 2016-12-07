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
    
    private static var cellSeparator: String {
        switch DebuggIt.sharedInstance.configType {
        case .jira:
            return "|"
        default:
            return " | "
        }
    }
    
    private static var deviceInfo: [String : String] {
        var info =  [
            "Device": UIDevice.current.modelName,
            "iOS version": UIDevice.current.systemVersion,
            ]
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            info["Application version"] = version
        }
        
        return info
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
    
    // MARK: - Public methods
    
    static func createContent(from report: Report) -> String {
        var lines = [String]()
        lines.append(boldTitle(stepsToReproduce) + report.stepsToReproduce.replacingOccurrences(of: "\n", with: "\n\n"))
        lines.append(boldTitle(actualBehavior) + report.actualBehavior.replacingOccurrences(of: "\n", with: "\n\n"))
        lines.append(boldTitle(expectedBehavior) + report.expectedBehavior.replacingOccurrences(of: "\n", with: "\n\n"))
        if DebuggIt.sharedInstance.configType == .github {
            lines.append(boldTitle(kind) + report.kind.name())
            lines.append(boldTitle(priority) + report.priority.name())
        }
        report.screenshotsUrls.forEach { (url) in
            lines.append(getScreenshotLink(url: url))
        }
        report.audioUrls.forEach { (url) in
            lines.append(url)
        }
        
        var content = lines.reduce("", {$0 + "\n\n" + $1})
        content += "\n" + createInfoTable()
    
        return content
    }
    
    // MARK: - Helper methods
    
    private static func boldTitle(_ title: String) -> String {
        return String(format: titleFormat, boldMark, title, boldMark)
    }
    
    private static func getScreenshotLink(url: String) -> String {
        return String(format: imageFormat, url)
    }
    
    private static func createInfoTable() -> String {
        var content = createTableHeader() + "\n"
        var cellCounter = 0
        
        if DebuggIt.sharedInstance.configType == .jira {
            content += cellSeparator
        }
        
        for (key, value) in deviceInfo {
            content += cellContent(key: key, value: value)
            content += endOfCell(counter: cellCounter)
            cellCounter += 1
        }
        return content
    }
    
    private static func cellContent(key: String, value: String) -> String {
        return [boldTitle(key), value].reduce("", { !$0.isEmpty ? $0  + cellSeparator + $1 : $0 + $1})
    }
    
    private static func endOfCell(counter cellCounter: Int) -> String {
        switch DebuggIt.sharedInstance.configType {
        case .jira:
            return cellCounter % 2 == 1 ? cellSeparator + "\n" + cellSeparator : cellSeparator
        default:
            return cellCounter % 2 == 1 ? "\n" : cellSeparator
        }
    }
    
    private static func createTableHeader() -> String {
        switch DebuggIt.sharedInstance.configType {
        case .bitbucket:
            return [" | | | ", "---|---|---|---"].reduce("", {$0 + "\n" + $1})
        case .github:
            return ["Key | Value | Key | Value ", "---|---|---|---"].reduce("", {$0 + "\n" + $1})
        default:
            return "|| Key || Value || Key || Value ||"
        }
    }
}
