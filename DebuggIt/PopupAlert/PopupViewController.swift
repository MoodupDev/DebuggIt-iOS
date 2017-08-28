//
//  PopupViewController.swift
//  DebuggIt
//
//  Created by Mikołaj Pęcak on 25.08.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: {
            completion?()
            DebuggIt.sharedInstance.moveApplicationWindowToFront()
        })
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
