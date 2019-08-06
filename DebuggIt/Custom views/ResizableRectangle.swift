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
            guard
                let touch = touches.first else { return }
            
            let touchPoint = touch.location(in: self)
            let previous = touch.previousLocation(in: self)
            
            let deltaWidth = touchPoint.x - previous.x
            let deltaHeight = touchPoint.y - previous.y
            
            let x = self.frame.origin.x
            let y = self.frame.origin.y
            
            let width = self.frame.size.width
            let height = self.frame.size.height
            
            if isResizingLowerRight {
                let switchInX = (touchPoint.x + deltaWidth) < self.resizeThumbViewSize
                let switchInY = (touchPoint.y + deltaWidth) < self.resizeThumbViewSize
                
                self.frame = CGRect(
                    x: x,
                    y: y,
                    width: switchInX ? self.resizeThumbViewSize : touchPoint.x + deltaWidth,
                    height: switchInY ? self.resizeThumbViewSize : touchPoint.y + deltaWidth
                )
                
                if switchInX && switchInY {
                    isResizingLowerRight = false
                    isResizingUpperLeft = true
                } else if switchInX {
                    isResizingLowerRight = false
                    isResizingLowerLeft = true
                } else if switchInY {
                    isResizingLowerRight = false
                    isResizingUpperRight = true
                }
            } else if isResizingUpperLeft {
                let switchInX = (width - deltaWidth) < self.resizeThumbViewSize
                let switchInY = (height - deltaHeight) < self.resizeThumbViewSize
                
                self.frame = CGRect(
                    x: x + (switchInX ? (width - self.resizeThumbViewSize) : deltaWidth),
                    y: y + (switchInY ? (height - self.resizeThumbViewSize) : deltaHeight),
                    width: switchInX ? self.resizeThumbViewSize : (width - deltaWidth),
                    height: switchInY ? self.resizeThumbViewSize : (height - deltaHeight)
                )
                
                if switchInX && switchInY {
                    isResizingUpperLeft = false
                    isResizingLowerRight = true
                } else if switchInX {
                    isResizingUpperLeft = false
                    isResizingUpperRight = true
                } else if switchInY {
                    isResizingUpperLeft = false
                    isResizingLowerLeft = true
                }
            } else if isResizingUpperRight {
                let switchInX = (width + deltaWidth) < self.resizeThumbViewSize
                let switchInY = (height - deltaHeight) < self.resizeThumbViewSize
                
                self.frame = CGRect(
                    x: x,
                    y: y + (switchInY ? (height - self.resizeThumbViewSize) : deltaHeight),
                    width: switchInX ? self.resizeThumbViewSize : (width + deltaWidth),
                    height: switchInY ? self.resizeThumbViewSize : (height - deltaHeight)
                )
                
                if switchInX && switchInY {
                    isResizingUpperRight = false
                    isResizingLowerLeft = true
                } else if switchInX {
                    isResizingUpperRight = false
                    isResizingUpperLeft = true
                } else if switchInY {
                    isResizingUpperRight = false
                    isResizingLowerRight = true
                }
            } else if isResizingLowerLeft {
                let switchInX = (width - deltaWidth) < self.resizeThumbViewSize
                let switchInY = (height + deltaHeight) < self.resizeThumbViewSize
                
                self.frame = CGRect(
                    x: x + (switchInX ? (width - self.resizeThumbViewSize) : deltaWidth),
                    y: y,
                    width: switchInX ? self.resizeThumbViewSize : (width - deltaWidth),
                    height: switchInY ? self.resizeThumbViewSize : (height + deltaHeight)
                )
                
                if switchInX && switchInY {
                    isResizingLowerLeft = false
                    isResizingUpperRight = true
                } else if switchInX {
                    isResizingLowerLeft = false
                    isResizingLowerRight = true
                } else if switchInY {
                    isResizingLowerLeft = false
                    isResizingUpperLeft = true
                }
            } else {
                guard let touchStart = self.touchStart else { return }
                self.center = CGPoint(x: self.center.x + touchPoint.x - touchStart.x, y: self.center.y + (touchPoint.y - touchStart.y))
            }
        }
    }
}
