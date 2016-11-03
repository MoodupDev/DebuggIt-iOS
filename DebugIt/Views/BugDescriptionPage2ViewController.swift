//
//  BugDescriptionPage2ViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 02.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class BugDescriptionPage2ViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var stepsToReproduceTextView: UITextView!
    @IBOutlet weak var actualBehaviorTextView: UITextView!
    @IBOutlet weak var expectedBehaviorTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        stepsToReproduceTextView.delegate = self
        actualBehaviorTextView.delegate = self
        expectedBehaviorTextView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension BugDescriptionPage2ViewController : UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == stepsToReproduceTextView {
            print("steps to reproduce")
            // TODO: save steps to reproduce to report
        } else if textView == actualBehaviorTextView {
            print("actual behavior")
            // TODO: save actual behavior to report
        } else {
            print("expected behavior")
            // TODO: save expected behavior to report
        }
    }
}
