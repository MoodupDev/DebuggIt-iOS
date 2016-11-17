//
//  BugDescriptionViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 03.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

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
        self.present(Utils.createAlert(title: "alert.title.send.report".localized(), message: "Do you want to send the report?", positiveAction: self.sendReport, negativeAction: {}), animated: true, completion: nil)
    }
    
    private func sendReport() {
        if DebuggIt.sharedInstance.report.title.isEmpty {
            present(Utils.createAlert(title: "alert.title.failure".localized(), message: "error.title.empty".localized(), positiveAction: {}), animated: true, completion: nil)
        } else {
            let alertController = Utils.createAlert(title: "alert.title.sending.screenshot".localized(), message: "alert.message.wait".localized())
            present(alertController, animated: true, completion: nil)
            
            DebuggIt.sharedInstance.sendReport(
                successBlock: {
                    alertController.dismiss(animated: false, completion: nil)
                    self.present(Utils.createAlert(title: "alert.title.success".localized(), message: "alert.message.saved.report".localized(), positiveAction: self.dissmissDebuggIt, negativeAction: nil), animated: true, completion: nil)
                    IQKeyboardManager.sharedManager().enable = false
            }, errorBlock: {
                (status, error) in
                alertController.dismiss(animated: false, completion: nil)
                self.present(Utils.createAlert(title: "alert.title.failure".localized(), message: error!, positiveAction: nil, negativeAction: nil), animated: true, completion: nil)
            })
        }
    }
    
    private func dissmissDebuggIt() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        DebuggIt.sharedInstance.report = Report()
        IQKeyboardManager.sharedManager().enable = false
    }
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        pageViewController?.openPage(sender.currentPage)
    }

}
