//
//  UIImage+Base64.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 04.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func toBase64String() -> String {
        let imageData = UIImagePNGRepresentation(self)!
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }
    
    class func fromBase64String(_ imageDataString: String) -> UIImage? {
        let dataDecoded = Data(base64Encoded: imageDataString, options: .ignoreUnknownCharacters)!
        return UIImage(data: dataDecoded)
    }
}
