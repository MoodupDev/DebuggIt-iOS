//
//  BugDescriptionViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 02.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class BugDescriptionPageViewController: UIPageViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        
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
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        // TODO: clear report
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.bugDescriptionPage(1), self.bugDescriptionPage(2)]
    }()
    
    private func bugDescriptionPage(_ page: Int) -> UIViewController {
        return UIStoryboard(name: "Report", bundle: nil) .
            instantiateViewController(withIdentifier: "BugDescriptionPage\(page)")
    }

    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        switch sender.currentPage {
        case 0:
            setViewControllers([orderedViewControllers.first!], direction: .reverse, animated: true, completion: nil)
        default:
            setViewControllers([orderedViewControllers.last!], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension BugDescriptionPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }

}

extension BugDescriptionPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if previousViewControllers.first != orderedViewControllers.first {
            pageControl.currentPage = 0
        } else {
            pageControl.currentPage = 1
        }
    }
}
