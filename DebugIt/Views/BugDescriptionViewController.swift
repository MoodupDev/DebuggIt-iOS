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
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        // TODO: clear report
    }
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        pageViewController?.openPage(sender.currentPage)
    }

}
