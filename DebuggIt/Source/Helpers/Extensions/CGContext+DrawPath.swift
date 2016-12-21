//
//  CGContext+DrawPath.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 16.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import Foundation
import UIKit

extension CGContext {
    func draw(_ path: UIBezierPath, lineWidth: CGFloat = 5.0, strokeColor: UIColor = .red, flush: Bool = false) {
        self.addPath(path.cgPath)
        self.setLineWidth(lineWidth)
        self.setStrokeColor(strokeColor.cgColor)
        self.setBlendMode(CGBlendMode.normal)
        self.setLineCap(CGLineCap.round)
        self.strokePath()
        if flush {
            self.flush()
        }
    }
}
