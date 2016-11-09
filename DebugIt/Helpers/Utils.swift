//
//  Utils.swift
//  DebugIt
//
//  Created by Bartek on 08/11/16.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import Foundation
import UIKit

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
    
    static func createAlert(title: String, message: String, positiveAction: (())? = nil, negativeAction: (())? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            (action: UIAlertAction!) in
            positiveAction
            alertController.dismiss(animated: false, completion: nil)
        }))
        
        if negativeAction != nil {            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
                (action: UIAlertAction!) in
                negativeAction
                alertController.dismiss(animated: false, completion: nil)
            }))
        }
        
        return alertController
    }
    
    static func createLoadingAlert(title: String, message: String) -> UIAlertController {
    
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }

    
}
