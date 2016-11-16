//
//  DrawingView.swift
//  DebugIt
//
//  Created by Bartek on 02/11/16.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class DrawingView: UIImageView {
    
    var active = true
    var type: DrawingType = .free
    
    private var lastPoint: CGPoint?
    
    private var paths = [UIBezierPath]()
    private var currentPath: UIBezierPath!
    
    private var lastDrawings = [DrawingType]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(active) {
            lastPoint = (touches.first?.location(in: self))!
            currentPath = initBezierPath()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(active) {
            let touch = touches.first
            let currentPoint:CGPoint = (touch?.location(in: self))!
            
            currentPath.move(to: lastPoint!)
            currentPath.addLine(to: currentPoint)
            
            draw(currentPath)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(active) {
            switch type {
            case .free:
                paths.append(currentPath)
            default:
                break
                
            }
            lastDrawings.append(type)
        }
    }
    
    private func initBezierPath(lineWidth: CGFloat = 5.0, lineCapStyle: CGLineCap = .round) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        path.lineCapStyle = lineCapStyle
        return path
    }
    
    func undo() {
        if let lastDrawing =  lastDrawings.last {
            switch lastDrawing {
            case .free:
                paths.removeLast()
                paths.forEach({ (path) in
                    draw(path)
                })
            default:
                break
            }
            lastDrawings.removeLast()
        }
    }
    
    private func draw(_ path: UIBezierPath) {
        UIGraphicsBeginImageContext(self.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        self.draw(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        
        context?.draw(path)
        
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}

enum DrawingType : Int {
    case free
    case rectangle
}
