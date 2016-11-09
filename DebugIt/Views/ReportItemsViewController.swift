//
//  ReportItemsViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 08.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit
import Nuke

private let screenshotReuseIdentifier = "ScreenshotCell"
private let newScreenshotReuseIdentifier = "NewScreenshotCell"
private let screenshotCellNib = "ScreenshotCollectionViewCell"
private let newScreenshotCellNib = "NewScreenshotCollectionViewCell"

class ReportItemsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView.register(UINib(nibName: screenshotCellNib, bundle: nil), forCellWithReuseIdentifier: screenshotReuseIdentifier)
        self.collectionView.register(UINib(nibName: newScreenshotCellNib, bundle: nil), forCellWithReuseIdentifier: newScreenshotReuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ReportItemsViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return DebuggIt.sharedInstance.report.screenshotsUrls.count + 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == DebuggIt.sharedInstance.report.screenshotsUrls.count {
            return collectionView.dequeueReusableCell(withReuseIdentifier: newScreenshotReuseIdentifier, for: indexPath) as! NewScreenshotCollectionViewCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: screenshotReuseIdentifier, for: indexPath) as! ScreenshotCollectionViewCell
            
            let screenshots = DebuggIt.sharedInstance.report.screenshotsUrls
            // Configure the cell
            if let url = URL(string: screenshots[indexPath.section]) {
                Nuke.loadImage(with: url, into: cell.screenshotImage)
            }
            cell.index = indexPath.section
            cell.collectonView = self.collectionView
            return cell
        }
    }
}
