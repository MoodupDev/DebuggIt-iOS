//
//  ReportItemsViewController.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 08.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import UIKit
import Nuke

private let screenshotReuseIdentifier = "ScreenshotCollectionViewCell"
private let newScreenshotReuseIdentifier = "NewScreenshotCollectionViewCell"
private let audioReuseIdentifier = "AudioCollectionViewCell"

class ReportItemsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView.register(UINib(nibName: screenshotReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: screenshotReuseIdentifier)
        self.collectionView.register(UINib(nibName: newScreenshotReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: newScreenshotReuseIdentifier)
        self.collectionView.register(UINib(nibName: audioReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: audioReuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ReportItemsViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let report = DebuggIt.sharedInstance.report
        return report.screenshotsUrls.count + report.audioUrls.count + 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemsCount = self.numberOfSections(in: collectionView)
        if indexPath.section == itemsCount - 1 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: newScreenshotReuseIdentifier, for: indexPath) as! NewScreenshotCollectionViewCell
        } else {
            let report = DebuggIt.sharedInstance.report
            
            if indexPath.section < report.audioUrls.count {
                return createAudioCell(for: indexPath)
            } else {
                return createScreenshotCell(for: indexPath)
            }
        }
    }
    
    func createScreenshotCell(for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: screenshotReuseIdentifier, for: indexPath) as! ScreenshotCollectionViewCell
        
        let report = DebuggIt.sharedInstance.report
        let screenshots = report.screenshotsUrls
        
        if let url = URL(string: screenshots[indexPath.section - report.audioUrls.count]) {
            Nuke.loadImage(with: url, into: cell.screenshotImage)
        }
        cell.index = indexPath.section
        
        return cell
    }
    
    func createAudioCell(for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: audioReuseIdentifier, for: indexPath) as! AudioCollectionViewCell
        cell.index = indexPath.section
        return cell
    }
}
