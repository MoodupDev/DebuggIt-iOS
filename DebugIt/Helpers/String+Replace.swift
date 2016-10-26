//
//  String+Replace.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 26.10.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import Foundation

extension String {
    
    func replaceFirst(replace: String, with: String) -> String {
        return self.replacingOccurrences(of: replace, with: with, options: NSString.CompareOptions.literal, range: nil)
    }
}
