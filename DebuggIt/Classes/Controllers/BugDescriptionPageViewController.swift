//
//  BugDescriptionViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 02.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit

class BugDescriptionPageViewController: UIPageViewController, DebuggItViewControllerProtocol {
    
    // MARK: - Properties
    
    weak var pageControl: UIPageControl?
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [
            Initializer.viewController(BugDescriptionPage1ViewController.self),
            Initializer.viewController(BugDescriptionPage2ViewController.self),
            ]
    }()
    
    // MARK: - Initialization

    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: options)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        if orderedViewControllers.first != nil {
            openPage(0)
        }
    }
}

// MARK: - UIPageViewControllerDataSource

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
    
    func openPage(_ page: Int) {
        if let pageControl = pageControl {
            guard 0...pageControl.numberOfPages - 1 ~= page else {
                return
            }
            setViewControllers([orderedViewControllers[page]], direction: page == 0 ? .reverse : .forward, animated: true, completion: nil)
        }
    }

}

// MARK: - UIPageViewControllerDelegate

extension BugDescriptionPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if previousViewControllers.first != orderedViewControllers.first {
                pageControl!.currentPage = 0
            } else {
                pageControl!.currentPage = 1
            }
        }
    }
}
