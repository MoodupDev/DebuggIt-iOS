//
//  DrawingView.swift
//  DebugIt
//
//  Created by Bartek on 02/11/16.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class DrawingView: UIImageView {
    
    private let rectangleOriginAdjustment: CGFloat = 2.5
    private let rectangleRightAdjustment: CGFloat = 5.0
    private let rectangleBottomAdjustment: CGFloat = 15.0
    
    var type: DrawingType = .arrow {
        didSet {
            pinCurrentRectangle()
        }
    }
    
    weak var delegate: DrawingViewDelegate?
    
    private var lastPoint: CGPoint!
    
    private var paths = [UIBezierPath]()
    private var nextPaths = [UIBezierPath]()
    private var currentPath: UIBezierPath!
    
    private var currentRectangle: ResizableRectangle!
    private var rectangles = [ResizableRectangle]()
    private var nextRectangles = [ResizableRectangle]()
    
    private var currentArrow: UIBezierPath!
    private var arrows = [UIBezierPath]()
    private var nextArrows = [UIBezierPath]()
    private var temporaryArrow = UIBezierPath()
    
    private var lastDrawings = [DrawingType]()
    private var nextDrawings = [DrawingType]()
    
    private lazy var convertRatio: CGSize = {
        let widthRatio = (self.image!.size.width / self.bounds.size.width)
        let heightRatio = (self.image!.size.height / self.bounds.size.height)
        return CGSize(width: widthRatio, height: heightRatio)
    }()
    
    private var isDrawingRect = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nextDrawings = []
        nextRectangles = []
        nextArrows = []
        nextPaths = []
        delegate?.highlightRedoButton(highlight: false)
        let touchLocation = (touches.first?.location(in: self))!
        lastPoint = convertToImageCoords(touchLocation)
        switch type {
        case .free:
            currentPath = initBezierPath()
        case .rectangle:
            if currentRectangle != nil {
                pinCurrentRectangle()
                isDrawingRect = false
            } else {
                currentRectangle = createRectangle(at: touchLocation)
                self.addSubview(currentRectangle)
                isDrawingRect = true
            }
        case .arrow:
            currentArrow = initBezierPath()
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
            redraw()
            let currentPoint: CGPoint = convertToImageCoords((touch?.location(in: self))!)
            temporaryArrow = UIBezierPath.bezierPathWithArrowFromPoint(startPoint: lastPoint, endPoint: currentPoint, tailWidth: Constants.arrowTailWidth, headWidth: Constants.arrowHeadWidth, headLength: Constants.arrowHeadLength)
            draw(temporaryArrow)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch type {
        case .free:
            paths.append(currentPath)
        case .arrow:
            redraw()
            let touch = touches.first
            let currentPoint: CGPoint = convertToImageCoords((touch?.location(in: self))!)
            currentArrow = UIBezierPath.bezierPathWithArrowFromPoint(startPoint: lastPoint, endPoint: currentPoint, tailWidth: Constants.arrowTailWidth, headWidth: Constants.arrowHeadWidth, headLength: Constants.arrowHeadLength)
            draw(currentArrow)
            arrows.append(currentArrow)
        default:
            break
        }
        if type != .rectangle || (type == .rectangle && isDrawingRect) {
            lastDrawings.append(type)
        }
        delegate?.highlightUndoButton(highlight: true)
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
    
    func isPortraitImage() -> Bool {
        guard let image = self.image else { return true }
        return image.size.height > image.size.width
    }
    
    func getWidth(containerWidth: CGFloat, containerHeight: CGFloat) -> CGFloat {
        guard let image = self.image else { return 0.0 }
        let imageRatio = image.size.width / image.size.height
        let containerRatio = containerWidth / containerHeight
        if imageRatio > containerRatio {
            return containerWidth
        } else {
            return (image.size.width * containerHeight) / image.size.height
        }
    }
    
    func getHeight(containerWidth: CGFloat, containerHeight: CGFloat) -> CGFloat {
        guard let image = self.image else { return 0.0 }
        let imageRatio = image.size.height / image.size.width
        let containerRatio = containerHeight / containerWidth
        if imageRatio > containerRatio {
            return containerHeight
        } else {
            return (image.size.height * containerWidth) / image.size.width
        }
    }
    
    func undo() {
        if let lastDrawing = lastDrawings.last {
            switch lastDrawing {
            case .free:
                if let lastPath = paths.last {
                    nextPaths.append(lastPath)
                    paths.removeLast()
                }
            case .rectangle:
                pinCurrentRectangle()
                if let lastRectangle = rectangles.last {
                    nextRectangles.append(lastRectangle)
                    rectangles.removeLast()
                }
            case .arrow:
                if let lastArrow = arrows.last {
                    nextArrows.append(lastArrow)
                    arrows.removeLast()
                }
            }
            delegate?.highlightRedoButton(highlight: true)
            redraw()
            nextDrawings.append(lastDrawing)
            lastDrawings.removeLast()
        }
        if lastDrawings != [] {
            delegate?.highlightUndoButton(highlight: true)
        } else {
            delegate?.highlightUndoButton(highlight: false)
        }
    }
    
    func redo() {
        if let nextDrawing = nextDrawings.last {
            switch nextDrawing {
            case .free:
                if let lastPath = nextPaths.last {
                    paths.append(lastPath)
                    nextPaths.removeLast()
                }
            case .rectangle:
                pinCurrentRectangle()
                if let lastRectangle = nextRectangles.last {
                    rectangles.append(lastRectangle)
                    nextRectangles.removeLast()
                }
            case .arrow:
                if let lastArrow = nextArrows.last {
                    arrows.append(lastArrow)
                    nextArrows.removeLast()
                }
            }
            delegate?.highlightUndoButton(highlight: true)
            redraw()
            lastDrawings.append(nextDrawing)
            nextDrawings.removeLast()
        }
        if nextDrawings != [] {
            delegate?.highlightRedoButton(highlight: true)
        } else {
            delegate?.highlightRedoButton(highlight: false)
        }
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
        topLeft.x += backgroundRect.origin.x + self.rectangleOriginAdjustment
        topLeft.y += backgroundRect.origin.y + self.rectangleOriginAdjustment
        let bottomLeft = CGPoint(x: topLeft.x, y: (topLeft.y + size.height) - self.rectangleBottomAdjustment)
        let topRight = CGPoint(x: topLeft.x + size.width - self.rectangleRightAdjustment, y: topLeft.y)
        let bottomRight = CGPoint(x: topRight.x, y: bottomLeft.y)
        
        path.move(to: topLeft)
        path.addLine(to: topRight)
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        path.addLine(to: topLeft)
        
        draw(path)
        
        rectangle.removeFromSuperview()
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

protocol DrawingViewDelegate: class {
    func highlightUndoButton(highlight: Bool)
    func highlightRedoButton(highlight: Bool)
}
