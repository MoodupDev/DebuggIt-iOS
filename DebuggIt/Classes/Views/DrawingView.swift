//
//  DrawingView.swift
//  DebugIt
//
//  Created by Bartek on 02/11/16.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class DrawingView: UIImageView {
    
    var type: DrawingType = .free {
        didSet {
            pinCurrentRectangle()
        }
    }
    
    private var lastPoint: CGPoint!
    
    private var paths = [UIBezierPath]()
    private var currentPath: UIBezierPath!
    
    var currentRectangle: ResizableRectangle!
    var rectangles = [ResizableRectangle]()
    
    private var lastDrawings = [DrawingType]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastPoint = (touches.first?.location(in: self))!
        switch type {
        case .free:
            currentPath = initBezierPath()
        case .rectangle:
            pinCurrentRectangle()
            currentRectangle = createRectangle(at: lastPoint)
            self.addSubview(currentRectangle)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        switch(type) {
        case .free:
            let currentPoint: CGPoint = (touch?.location(in: self))!
            
            currentPath.move(to: lastPoint)
            currentPath.addLine(to: currentPoint)
            
            draw(currentPath)
            
            lastPoint = currentPoint
        case .rectangle:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch type {
        case .free:
            paths.append(currentPath)
        default:
            break
        }
        lastDrawings.append(type)
    }
    
    private func initBezierPath(lineWidth: CGFloat = 5.0, lineCapStyle: CGLineCap = .round) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        path.lineCapStyle = lineCapStyle
        return path
    }
    
    private func createRectangle(at point: CGPoint) -> ResizableRectangle {
        let rectangle = ResizableRectangle.instantiateFromNib()
        
        rectangle.backgroundView.layer.borderColor = UIColor.red.cgColor
        rectangle.backgroundView.layer.borderWidth = 5.0
        
        rectangle.center.y = point.y
        rectangle.center.x = point.x
    
        return rectangle
    }
    
    func undo() {
        if let lastDrawing =  lastDrawings.last {
            switch lastDrawing {
            case .free:
                paths.removeLast()
            case .rectangle:
                pinCurrentRectangle()
                rectangles.removeLast()
            }
            redraw()
            lastDrawings.removeLast()
        }
    }
    
    private func pinCurrentRectangle() {
        if currentRectangle != nil && !currentRectangle.isPinned {
            currentRectangle.pin()
            draw(currentRectangle)
            rectangles.append(currentRectangle)
            currentRectangle.removeFromSuperview()
            currentRectangle = nil
        }
    }
    
    private func redraw() {
        self.image = DebuggIt.sharedInstance.report.currentScreenshot
        rectangles.forEach({ (rectangle) in
            draw(rectangle)
        })
        paths.forEach({ (path) in
            draw(path)
        })
    }
    
    private func draw(_ path: UIBezierPath) {
        UIGraphicsBeginImageContext(self.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        self.draw(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        
        context?.draw(path)
        
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    private func draw(_ rectangle: ResizableRectangle) {
        let path = initBezierPath()
        
        let rectangleRect = self.convert(rectangle.frame, to: self)
        let backgroundRect = self.convert(rectangle.backgroundView.frame, to: self)
        
        let size = backgroundRect.size
        
        var topLeft = rectangleRect.origin
        topLeft.x += backgroundRect.origin.x
        topLeft.y += backgroundRect.origin.y
        let bottomLeft = CGPoint(x: topLeft.x, y: topLeft.y + size.height)
        let topRight = CGPoint(x: topLeft.x + size.width, y: topLeft.y)
        let bottomRight = CGPoint(x: topRight.x, y: bottomLeft.y)
        
        path.move(to: topLeft)
        path.addLine(to: topRight)
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        path.addLine(to: topLeft)
        
        draw(path)
        
        rectangle.removeFromSuperview()
    }
}

enum DrawingType : Int {
    case free
    case rectangle
}
