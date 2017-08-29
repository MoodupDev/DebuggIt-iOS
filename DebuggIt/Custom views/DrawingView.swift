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
    
    private var currentRectangle: ResizableRectangle!
    private var rectangles = [ResizableRectangle]()
    
    private var currentArrow: ResizableArrow!
    private var arrows = [ResizableArrow]()
    
    private var lastDrawings = [DrawingType]()
    
    private lazy var convertRatio: CGSize = {
        let widthRatio = (self.image!.size.width / self.bounds.size.width)
        let heightRatio = (self.image!.size.height / self.bounds.size.height)
        return CGSize(width: widthRatio, height: heightRatio)
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLocation = (touches.first?.location(in: self))!
        lastPoint = convertToImageCoords(touchLocation)
        switch type {
        case .free:
            currentPath = initBezierPath()
        case .rectangle:
            pinCurrentRectangle()
            currentRectangle = createRectangle(at: touchLocation)
            self.addSubview(currentRectangle)
        case .arrow:
            pinCurrentArrow()
            currentArrow = createArrow(at: touchLocation)
            self.addSubview(currentArrow)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        switch(type) {
        case .free:
            let currentPoint: CGPoint = convertToImageCoords((touch?.location(in: self))!)
            
            currentPath.move(to: lastPoint)
            currentPath.addLine(to: currentPoint)
            
            draw(currentPath)
            
            lastPoint = currentPoint
        case .rectangle:
            break
        case .arrow:
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
    
    private func createArrow(at point: CGPoint) -> ResizableArrow {
        let arrow = ResizableArrow.instantiateFromNib()
        arrow.center.y = point.y
        arrow.center.x = point.x
        return arrow
    }
    
    func undo() {
        if let lastDrawing = lastDrawings.last {
            switch lastDrawing {
            case .free:
                paths.removeLast()
            case .rectangle:
                pinCurrentRectangle()
                rectangles.removeLast()
            case .arrow:
                // TODO arrow method
                print("undo arrow move")
            }
            redraw()
            lastDrawings.removeLast()
        }
    }
    
    func redo() {
        // TODO redo function
    }
    
    func pinCurrentRectangle() {
        if currentRectangle != nil && !currentRectangle.isPinned {
            currentRectangle.pin()
            draw(currentRectangle)
            rectangles.append(currentRectangle)
            currentRectangle.removeFromSuperview()
            currentRectangle = nil
        }
    }
    
    func pinCurrentArrow() {
        if currentArrow != nil && !currentArrow.isPinned {
            currentArrow.pin()
            draw(currentArrow)
            arrows.append(currentArrow)
            currentArrow.removeFromSuperview()
            currentArrow = nil
        }
    }
    
    private func redraw() {
        self.image = DebuggIt.sharedInstance.report.currentScreenshot
        rectangles.forEach({ (rectangle) in
            draw(rectangle)
        })
        arrows.forEach({ (arrow) in
            draw(arrow)
        })
        paths.forEach({ (path) in
            draw(path)
        })
    }
    
    private func draw(_ path: UIBezierPath) {
        UIGraphicsBeginImageContext(self.image!.size)
        let context = UIGraphicsGetCurrentContext()
        
        image?.draw(in: CGRect(x: 0, y: 0, width: self.image!.size.width, height: self.image!.size.height))
        
        context?.draw(path)
        
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    private func draw(_ rectangle: ResizableRectangle) {
        let path = initBezierPath()
        
        let rectangleRect = convertToImageCoords(self.convert(rectangle.frame, to: self))
        let backgroundRect = convertToImageCoords(self.convert(rectangle.backgroundView.frame, to: self))
        
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
    
    private func draw(_ arrow: ResizableArrow) {
        let path = initBezierPath()
        
        let arrowRect = convertToImageCoords(self.convert(arrow.frame, to: self))
        let backgroundRect = convertToImageCoords(self.convert(arrow.backgroundView.frame, to: self))
        
        let size = backgroundRect.size
        
        var topLeft = arrowRect.origin
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
        
        arrow.removeFromSuperview()
    }
    
    private func convertToImageCoords(_ location: CGPoint) -> CGPoint {
        let x = location.x * convertRatio.width
        let y = location.y * convertRatio.height
        return CGPoint(x: x, y: y)
    }
    
    private func convertToImageCoords(_ rect: CGRect) -> CGRect {
        let height = rect.height * convertRatio.height
        let width = rect.width * convertRatio.width
        
        let origin = convertToImageCoords(rect.origin)
        let size = CGSize(width: width, height: height)
        
        return CGRect(origin: origin, size: size)
    }
}

enum DrawingType : Int {
    case free
    case rectangle
    case arrow
}
