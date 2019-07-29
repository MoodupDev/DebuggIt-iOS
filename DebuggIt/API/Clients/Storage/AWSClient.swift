//
//  ApiClient.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 04.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import Alamofire
import SwiftyJSON
import AWSS3

final class AWSClient: ApiStorageProtocol {
    
    private let s3URL = "https://s3.%@.amazonaws.com/%@/%@"
    
    private let uploadedImagesFolder = "image/"
    private let uploadedImagePrefix = "image"
    private let uploadedImageSuffix = ".png"
    private let uploadedImageContentType = "image/png"
    private let uploadedAudioFolder = "audio/"
    private let uploadedAudioPrefix = "audio"
    private let uploadedAudioSuffix = ".mpeg"
    private let uploadedAudioContentType = "audio/mpeg"
    
    private let bucketName: String
    private var region: String?
    
    init(bucketName: String, regionType: AWSRegionType, identityPool: String) {
        self.bucketName = bucketName
        if let substring = identityPool.split(separator: ":").first {
            self.region = String(substring)
        }
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: regionType,
                                                                identityPoolId: identityPool)
        
        let configuration = AWSServiceConfiguration(region: regionType, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    func upload(_ type: MediaType, data base64EncodedString: String, successBlock: @escaping () -> (), errorBlock: @escaping (Int?, String?) -> ()) {
        
        let filePath = generateFilePath(type)
        let contentType = type == .image ? uploadedImageContentType : uploadedAudioContentType
        guard let data = Data(base64Encoded: base64EncodedString, options: .ignoreUnknownCharacters) else { return }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            if error != nil {
                errorBlock(nil, error?.localizedDescription)
            } else {
                var tempURL: String?
                if let region = self.region {
                    tempURL = String(format: self.s3URL, arguments: [region, self.bucketName, filePath])
                } else {
                    guard let substring = task.response?.url?.absoluteString.split(separator: "?").first else {
                        errorBlock(nil, nil)
                        return
                    }
                    tempURL = String(substring)
                }
                guard let url = tempURL else {
                    errorBlock(nil, nil)
                    return
                }
                switch(type) {
                case .image:
                    let screenName = DebuggIt.sharedInstance.report.currentScreenshotScreenName!
                    DebuggIt.sharedInstance.report.screenshots.append(Screenshot(screenName: screenName, url: url))
                case .audio:
                    DebuggIt.sharedInstance.report.audioUrls.append(url)
                }
                successBlock()
            }
        }
        
        AWSS3TransferUtility.default()
            .uploadData(data, bucket: self.bucketName,key: filePath, contentType: contentType, expression: nil, completionHandler: completionHandler)
    }
    
    func generateFilePath(_ type: MediaType) -> String {
        switch type {
        case .image:
            return uploadedImagesFolder + generateFileName(type)
        case.audio:
            return uploadedAudioFolder + generateFileName(type)
        }
    }
    
    func generateFileName(_ type: MediaType) -> String {
        switch type {
        case .image:
            return "\(uploadedImagePrefix)_\(Int(Date().timeIntervalSince1970))\(uploadedImageSuffix)"
        case.audio:
            return "\(uploadedAudioPrefix)_\(Int(Date().timeIntervalSince1970))\(uploadedAudioSuffix)"
        }
    }
}
