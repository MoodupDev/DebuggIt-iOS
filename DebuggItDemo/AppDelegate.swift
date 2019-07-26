//
//  AppDelegate.swift
//  DebuggItDemo
//
//  Created by Arkadiusz Żmudzin on 10.01.2017.
//  Copyright © 2017 Mood Up. All rights reserved.
//

import UIKit
import DebuggIt
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DebuggIt.sharedInstance
            .initAWS(bucketName: "staging.debugg.it", regionType: .EUCentral1, identityPool: "***REMOVED***")
//            .initDefaultStorage(url: "https://url-to-backend.com/api", imagePath: "/debuggit/uploadImage", audioPath: "/debuggit/uploadAudio")
//            .initCustomStorage(uploadImage: { (base64, delegate) in
//                self.send(url: "https://url-to-backend.com/debuggit/uploadImage", base: base64, delegate: delegate)
//            }, uploadAudio: { (base64, delegate) in
//                self.send(url: "https://debuggit-api.herokuapp.com/debuggit/uploadAudio", base: base64, delegate: delegate)
//            })
            .initBitbucket(repoSlug: "BugReporter", accountName: "MoodUp")
        DebuggIt.sharedInstance.recordingEnabled = true
        return true
    }
    
    func send(url: String, base: String, delegate: ApiClientDelegate) {
        let params : Parameters = [
            "data": base,
        ]
        
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let value = JSON(value)
                let url = value["url"].stringValue
                delegate.successClousure(url)
            case .failure(let error as AFError):
                delegate.errorClousure(nil, error.errorDescription)
            default:
                delegate.errorClousure(nil, nil)
                
            }
            
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

