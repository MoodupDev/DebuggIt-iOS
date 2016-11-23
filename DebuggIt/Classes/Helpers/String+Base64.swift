//
//  String+Base64.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 26.10.2016.
//  Copyright © 2016 Mood Up. All rights reserved.
//

import UIKit

extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
