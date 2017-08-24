//
//  DebuggItButton.swift
//  DebuggIt
//
//  Created by Bartek on 26/10/16.
//  Copyright © 2016 Mood Up. All rights reserved.
//

import UIKit

class DebuggItButton: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var top: UIView!
    @IBOutlet weak var edge: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func instantiateFromNib() -> DebuggItButton {
        let button = Initializer.view(DebuggItButton.self) as! DebuggItButton
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        
        button.layoutIfNeeded()
        
        button.imageView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 5)
        button.top.roundCorners(corners: [.bottomLeft, .topLeft], radius: 5)
        button.edge.roundCorners(corners: [.bottomLeft, .topLeft], radius: 5)
        return button
    }

}
