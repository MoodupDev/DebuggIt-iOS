//
//  ResizableRectangle.swift
//  DebugIt
//
//  Created by Bartek on 03/11/16.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class ResizableRectangle: UIView {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet var corners: [UIImageView]!
    
    let resizeThumbSize: CGFloat = 45.0
    let resizeThumbViewSize: CGFloat = 16.0
    var isResizingLowerRight = false
    var isResizingUpperRight = false
    var isResizingLowerLeft = false
    var isResizingUpperLeft = false
    var touchStart: CGPoint?
    var isPinned = false
    var switchInX = false
    var switchInY = false
    
    class func instantiateFromNib() -> ResizableRectangle {
        return Initializer.view(ResizableRectangle.self) as! ResizableRectangle
    }
    
    func pin() {
        isPinned = true
        corners.forEach { (corner) in
            corner.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!isPinned) {
            let touch = touches.first
            
            touchStart = touch?.location(in: self)
            isResizingLowerRight = (self.bounds.size.width - touchStart!.x < resizeThumbSize && self.bounds.size.height - touchStart!.y < resizeThumbSize);
            isResizingUpperLeft = (touchStart!.x < resizeThumbSize && touchStart!.y < resizeThumbSize);
            isResizingUpperRight = (self.bounds.size.width - touchStart!.x < resizeThumbSize && touchStart!.y < resizeThumbSize);
            isResizingLowerLeft = (touchStart!.x < resizeThumbSize && self.bounds.size.height - touchStart!.y < resizeThumbSize);
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!isPinned) {
            let touchPoint = touches.first?.location(in: self)
            let previous = touches.first?.previousLocation(in: self)
            
            let deltaWidth = (touchPoint?.x)! - (previous?.x)!
            let deltaHeight = (touchPoint?.y)! - (previous?.y)!
            
            let x = self.frame.origin.x
            let y = self.frame.origin.y
            
            let width = self.frame.size.width
            let height = self.frame.size.height
            
            if isResizingLowerRight {
                switchInX = ((touchPoint?.x)! + deltaWidth) < self.resizeThumbViewSize
                self.frame = CGRect(x: x, y: y, width: switchInX ? self.resizeThumbViewSize : (touchPoint?.x)! + deltaWidth, height: (touchPoint?.y)! + deltaWidth)
                if(switchInX) {
                    isResizingLowerRight = false
                    isResizingLowerLeft = true
                }
                switchInX = false
            } else if isResizingUpperLeft {
                self.frame = CGRect(x: x + deltaWidth, y: y + deltaHeight, width: width - deltaWidth, height: height - deltaHeight)
            } else if isResizingUpperRight {
                self.frame = CGRect(x: x, y: y + deltaHeight, width: width + deltaWidth, height: height - deltaHeight)
            } else if isResizingLowerLeft {
                switchInX = (width - deltaWidth) < self.resizeThumbViewSize
                self.frame = CGRect(x: x + (switchInX ? (width - self.resizeThumbViewSize) : deltaWidth), y: y, width: switchInX ? self.resizeThumbViewSize : (width - deltaWidth), height: height + deltaHeight)
                if(switchInX) {
                    isResizingLowerRight = true
                    isResizingLowerLeft = false
                }
                switchInX = false
            } else {
                self.center = CGPoint(x: self.center.x + (touchPoint?.x)! - (touchStart?.x)!, y: self.center.y + (touchPoint?.y)! - (touchStart?.y)!)
            }
        }
    }
}
