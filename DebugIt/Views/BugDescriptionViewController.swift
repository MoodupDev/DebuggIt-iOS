//
//  BugDescriptionViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 03.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class BugDescriptionViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    weak var pageViewController : BugDescriptionPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bugDescriptionPageViewController" {
            pageViewController = segue.destination as? BugDescriptionPageViewController
            pageViewController?.pageControl = self.pageControl
        }
    }
    
    // MARK: Actions
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Send report", message: "Do you want to send the report?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction!) in
            alertController.dismiss(animated: false, completion: nil)
            self.sendReport()
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction!) in
            alertController.dismiss(animated: false, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func sendReport() {
        let alertController = UIAlertController(title: "Sending report", message: "Wait for end...", preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        
        DebuggIt.sharedInstance.sendReport(
            successBlock: {
                alertController.dismiss(animated: true, completion: nil)
                print("Success motherfucker")
            }, errorBlock: {
                (status, error) in
                alertController.dismiss(animated: true, completion: nil)
                print("Fail motherfucker\n" + error!)
        })
    }
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        DebuggIt.sharedInstance.report = Report()
    }
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        pageViewController?.openPage(sender.currentPage)
    }

}
