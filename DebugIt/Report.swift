//
//  Report.swift
//  DebuggIt
//
//  Created by Bartek on 25/10/16.
//  Copyright © 2016 Mood Up. All rights reserved.
//

import UIKit

class Report {
    
    var title = ""
    
    var kind : ReportKind = .bug
    var priority : ReportPriority = .medium
    var configType : ConfigType?

    var stepsToReproduce = ""
    var actualBehavior = ""
    var expectedBehavior = ""
    
    var screenshots = [UIImage]()
    var screenshotsUrls = [String]()
    
    init() {
       
    }
}
