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

class AWSClient: ApiStorageProtocol {
    
    private let uploadedImagesFolder = "image/";
    private let uploadedImagePrefix = "image";
    private let uploadedImageSuffix = ".png";
    private let uploadedImageContentType = "image/png";
    private let uploadedAudioFolder = "audio/";
    private let uploadedAudioPrefix = "audio";
    private let uploadedAudioSuffix = ".mpeg";
    private let uploadedAudioContentType = "audio/mpeg";
    
    private let transferKey = "transfer-key"
    
    private let bucketName: String
    
    init(bucketName: String, regionType: AWSRegionType, identityPool: String) {
        self.bucketName = bucketName
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: regionType,
                                                                identityPoolId: identityPool)
        
        let configuration = AWSServiceConfiguration(region: regionType, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        let tuConf = AWSS3TransferUtilityConfiguration()
        tuConf.isAccelerateModeEnabled = true
        AWSS3TransferUtility.register(
            with: configuration!,
            transferUtilityConfiguration: tuConf,
            forKey: self.transferKey
        ) { (error) in
            if let error = error {
                //TODO Handle registration error.
            }
        }
    }
    
    func upload(_ type: MediaType, data base64EncodedString: String, successBlock: @escaping () -> (), errorBlock: @escaping (Int?, String?) -> ()) {
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            if error != nil {
                errorBlock(nil, error?.localizedDescription)
            } else {
                successBlock()
            }
        }
        let contentType = type == .image ? uploadedImageContentType : uploadedAudioContentType
        let filePath = generateFilePath(type)
        let transferUtility = AWSS3TransferUtility.default()
        guard let data = Data(base64Encoded: base64EncodedString) else { return }
        transferUtility.uploadData(data, key: filePath, contentType: contentType, expression: nil, completionHandler: completionHandler)
    }
    
    func generateFilePath(_ type: MediaType) -> String {
        switch type {
        case .image:
            return uploadedImagesFolder + generateFileName()
        case.audio:
            return uploadedAudioFolder + generateFileName()
        }
    }
    
    func generateFileName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd hh:mm:ss"
        let formattedString = formatter.string(from: Date())
        
        return uploadedImagePrefix + " " + formattedString + uploadedImageSuffix;
    }
}
