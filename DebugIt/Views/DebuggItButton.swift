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
    
    class func instantiateFromNib() -> DebuggItButton {
        return UINib(nibName: "DebuggItButton", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DebuggItButton
    }

}
