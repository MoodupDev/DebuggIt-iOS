//
//  RoundedButton.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 03.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat = CGFloat(5) {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    //Normal state background and border
    @IBInspectable var normalBorderColor: UIColor? {
        didSet {
            layer.borderColor = normalBorderColor?.cgColor
        }
    }
    
    @IBInspectable var normalBackgroundColor: UIColor? = UIColor.clear {
        didSet {
            setBackgroundColor(color: normalBackgroundColor, forState: .normal)
        }
    }
    
    @IBInspectable var normalTextColor: UIColor? {
        didSet {
            setTitleColor(normalTextColor, for: .normal)
        }
    }
    
    
    //Selected state background
    
    @IBInspectable var selectedBackgroundColor: UIColor? {
        didSet {
            setBackgroundColor(color: selectedBackgroundColor, forState: .selected)
            tintColor = .clear
        }
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? selectedBackgroundColor : normalBackgroundColor
        }
    }
    
    
    private func setBackgroundColor(color: UIColor?, forState: UIControl.State){
        if color != nil {
            setBackgroundImage(UIImage.imageWithColor(color: color!, size: self.intrinsicContentSize), for: forState)
        } else {
            setBackgroundImage(nil, for: forState)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        clipsToBounds = true
        
        if borderWidth > 0 {
            if state == .normal && layer.borderColor != normalBorderColor?.cgColor {
                layer.borderColor = normalBorderColor?.cgColor
            } else if state == .selected {
                layer.borderColor = selectedBackgroundColor?.cgColor
            }
        }
    }
    
}

//Extension Required by RoundedButton to create UIImage from UIColor
extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
