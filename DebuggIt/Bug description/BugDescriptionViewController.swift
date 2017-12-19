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
    @IBOutlet weak var container: UIView!
    var pageViewController : BugDescriptionPageViewController!
    var viewModel = BugDescriptionViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController = BugDescriptionPageViewController()
        pageViewController.pageControl = self.pageControl
        
        self.embed(pageViewController, in: container)
    }
    
    // MARK: Actions
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        self.resignFirstResponder()
        viewModel.sendReport(viewController: self)
    }
    
    private func dissmissDebuggIt() {
        self.dismiss(animated: true, completion: {
            self.viewModel.moveApplicationWindowToFront()
        })
    }
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: {
            self.viewModel.moveApplicationWindowToFront()
        })
        viewModel.clearData()
    }
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        pageViewController.openPage(sender.currentPage)
    }

}
