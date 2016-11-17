//
//  BackgroundView.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 16.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

@IBDesignable
class BackgroundView: UIView {
    
    @IBOutlet weak var usableArea: UIView!
    
    var contentView : UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        contentView = loadViewFromNib()
        // use bounds not frame or it'll be offset
        contentView.frame = bounds
        
        self.layer.cornerRadius = 5
        
        // Make the view stretch with containing view
        contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(contentView)
        bringSubviewsToFront()
    }
    
    func loadViewFromNib() -> UIView! {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func bringSubviewsToFront() {
        subviews.reversed().forEach { (subview) in
            bringSubview(toFront: subview)
        }
    }
}