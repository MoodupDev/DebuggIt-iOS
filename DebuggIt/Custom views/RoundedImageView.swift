//
//  RoundedImageView.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 10.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = CGFloat(5) {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = false
            clipsToBounds = true
        }
    }
    
    // MARK: - Border
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = CGFloat(0) {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

}
