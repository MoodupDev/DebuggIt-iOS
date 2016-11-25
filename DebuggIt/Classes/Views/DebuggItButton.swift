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
    @IBOutlet weak var edge: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func instantiateFromNib() -> DebuggItButton {
        return Initializer.view(DebuggItButton.self) as! DebuggItButton
    }

}
