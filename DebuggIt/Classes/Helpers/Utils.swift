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
}
