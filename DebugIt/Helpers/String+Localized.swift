//
//  String+Localized.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 10.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import Foundation

extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
