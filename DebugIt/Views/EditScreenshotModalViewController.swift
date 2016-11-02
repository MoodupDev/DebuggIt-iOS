//
//  EditScreenshotModalViewController.swift
//  DebugIt
//
//  Created by Bartek on 27/10/16.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class EditScreenshotModalViewController: UIViewController {

    @IBOutlet weak var screenshotSurface: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenshotSurface.image = DebuggIt.sharedInstance.report.screenshots.last
    }
    
    
    @IBAction func tapDone(_ sender: UIButton) {
        //todo go to the form modal
    }

    @IBAction func tapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
