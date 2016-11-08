//
//  DrawingView.swift
//  DebugIt
//
//  Created by Bartek on 02/11/16.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class DrawingView: UIImageView {
    
    let red:CGFloat = 255.0
    let green:CGFloat = 0.0
    let blue:CGFloat = 0.0
    let paintAlpha:CGFloat = 1.0
    let lineWidth:CGFloat = 5.0
    
    var lastPoint:CGPoint?
    var isDrawing = false
    var isActive = true
    
    func active(isActive: Bool) {
        self.isActive = isActive
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(isActive) {
            isDrawing = true;
            lastPoint = (touches.first?.location(in: self))!
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(isActive) {
            isDrawing = true
            let touch = touches.first
            let currentPoint:CGPoint = (touch?.location(in: self))!
            
            UIGraphicsBeginImageContext(self.frame.size)
            let context = UIGraphicsGetCurrentContext()
            
            self.draw(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            
            context?.move(to: lastPoint!)
            context?.addLine(to: currentPoint)
            context?.setLineWidth(lineWidth)
            context?.setStrokeColor(red: red, green: green, blue: blue, alpha: paintAlpha)
            context?.setBlendMode(CGBlendMode.normal)
            context?.setLineCap(CGLineCap.round)
            context?.strokePath()
            
            self.image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!isDrawing && isActive) {
            UIGraphicsBeginImageContext(self.frame.size)
            let context = UIGraphicsGetCurrentContext()
            
            self.draw(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            
            context?.setLineCap(CGLineCap.round)
            context?.setLineWidth(lineWidth)
            context?.setStrokeColor(red: red, green: green, blue: blue, alpha: paintAlpha)
            context?.move(to: lastPoint!)
            context?.addLine(to: lastPoint!)
            context?.strokePath()
            context?.flush()
            
            self.image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
        }
    }
}
