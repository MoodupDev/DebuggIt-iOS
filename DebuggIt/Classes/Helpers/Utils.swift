//
//  Utils.swift
//  DebugIt
//
//  Created by Bartek on 08/11/16.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

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
    
    static func convert(fromKind: ReportKind) -> String {
        if(DebuggIt.sharedInstance.configType == .jira) {
            switch fromKind {
            case .enhancement:
                return Constants.Jira.task
            default:
                return fromKind.rawValue
            }
        } else {
            return fromKind.rawValue
        }
    }
    
    static func createAlert(title: String, message: String, positiveAction: (() -> Void)? = nil, negativeAction: (() -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let positiveAction = positiveAction {
            alertController.addAction(UIAlertAction(title: "alert.button.ok".localized(), style: .default, handler: {
                (action: UIAlertAction!) in
                positiveAction()
                alertController.dismiss(animated: false, completion: nil)
            }))
        }
        
        if let negativeAction = negativeAction {
            alertController.addAction(UIAlertAction(title: "alert.button.cancel".localized(), style: .default, handler: {
                (action: UIAlertAction!) in
                negativeAction()
                alertController.dismiss(animated: false, completion: nil)
            }))
        }
        
        return alertController
    }
    
    static func parseError(_ error: String?, defaultMessage message: String = "error.general".localized()) -> String {
        if let errorString = error {
            let json = JSON.parse(errorString)
            if let error = json["error_description"].string {
                return error
            } else if let error = json["message"].string {
                return error
            }
            return message
        } else {
            return message
        }
    }
    
    static func getBundle(forClass: AnyClass) -> Bundle {
        let podBundle = Bundle(for: forClass)
        
        let bundleURL = podBundle.url(forResource: "DebuggIt", withExtension: "bundle")
        return Bundle(url: bundleURL!)!
    }
    
    static func initViewController<T: UIViewController>(_ withClass: UIViewController.Type) -> T {
        return withClass.init(nibName: String(describing: withClass), bundle: getBundle(forClass: withClass)) as! T
    }
}
