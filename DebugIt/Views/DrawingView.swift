//
//  DrawingView.swift
//  DebugIt
//
//  Created by Bartek on 02/11/16.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class DrawingView: UIImageView {
    
    var lastPoint:CGPoint?
    var isDrawing = false
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDrawing = true;
        lastPoint = (touches.first?.location(in: self))!
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDrawing = true
        let touch = touches.first
        let currentPoint:CGPoint = (touch?.location(in: self))!
        
        UIGraphicsBeginImageContext(self.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        self.draw(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        
        context?.move(to: lastPoint!)
        context?.addLine(to: currentPoint)
        context?.setLineWidth(10.0)
        context?.setStrokeColor(red: 255.0, green: 0.0, blue: 255.0, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.strokePath()
        
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        lastPoint = currentPoint
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!isDrawing) {
            UIGraphicsBeginImageContext(self.frame.size)
            let context = UIGraphicsGetCurrentContext()

            self.draw(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            
            context?.setLineCap(CGLineCap.round)
            context?.setLineWidth(10.0)
            context?.setStrokeColor(red: 255.0, green: 0.0, blue: 255.0, alpha: 1.0)
            context?.move(to: lastPoint!)
            context?.addLine(to: lastPoint!)
            context?.strokePath()
            context?.flush()
        
            self.image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
        }
    }
}
