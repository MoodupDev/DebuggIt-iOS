//
//  ViewController.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 11/23/2016.
//  Copyright (c) 2016 Arkadiusz Żmudzin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showAlert(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Sample alert", message: "Sample alert messsage", preferredStyle: .actionSheet)
        let actionClose = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        
        alertController.addAction(actionClose)
        
        self.present(alertController, animated: true, completion: nil)
    }

}

