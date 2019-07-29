//
//  ApiClient.swift
//  DebuggIt
//
//  Created by Piotr Gomoła on 23/07/2019.
//  Copyright © 2019 Mood Up. All rights reserved.
//

import Foundation

protocol UploadDelegate: AnyObject {
    func onUploadSuccess(fileURL: String)
    func onError(code: Int?, message: String?)
}

final class ApiClient: ApiStorageProtocol {
    
    private var url: URL?
    private var imagePath, audioPath: String?
    
    private var uploadImage, uploadAudio: ((String, ApiClientDelegate) -> ())?
    
    init(url: URL, imagePath: String, audioPath: String) {
        self.url = url
        self.imagePath = imagePath
        self.audioPath = audioPath
    }
    
    init(uploadImage: @escaping ((String, ApiClientDelegate) -> ()),
         uploadAudio: @escaping ((String, ApiClientDelegate) -> ())) {
        self.uploadImage = uploadImage
        self.uploadAudio = uploadAudio
    }
    
    func upload(_ type: MediaType, data base64EncodedString: String, successBlock: @escaping () -> (), errorBlock: @escaping (Int?, String?) -> ()) {
        if url != nil {
            manageDefaultRequest(type, data: base64EncodedString, successBlock: successBlock, errorBlock: errorBlock)
        } else {
            manageCustomRequest(type, data: base64EncodedString, successBlock: successBlock, errorBlock: errorBlock)
        }
    }
    
    private func manageCustomRequest(_ type: MediaType, data base64EncodedString: String, successBlock: @escaping () -> (), errorBlock: @escaping (Int?, String?) -> ()) {
        switch type {
        case .image:
            uploadImage?(base64EncodedString, ApiClientDelegate(onUploadSuccess: { (fileURL) in
                let screenName = DebuggIt.sharedInstance.report.currentScreenshotScreenName!
                DebuggIt.sharedInstance.report.screenshots.append(Screenshot(screenName: screenName, url: fileURL))
                successBlock()
            }, onError: { (code, message) in
                errorBlock(code, message)
            }))
        case .audio:
            uploadAudio?(base64EncodedString, ApiClientDelegate(onUploadSuccess: { (fileURL) in
                DebuggIt.sharedInstance.report.audioUrls.append(fileURL)
            }, onError: { (code, message) in
                errorBlock(code, message)
            }))
        }
    }
    
    private func manageDefaultRequest(
        _ type: MediaType,
        data base64EncodedString: String,
        successBlock: @escaping () -> (),
        errorBlock: @escaping (Int?, String?) -> ()) {
        
        guard let url = self.url, let imagePath = self.imagePath, let audioPath = self.audioPath else { return }
        
        let requestURL = url.appendingPathComponent(type == .image ? imagePath : audioPath)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "data": base64EncodedString,
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.onDefaultResult(
                    type: type,
                    data: data,
                    response: response,
                    error: error,
                    successBlock: successBlock,
                    errorBlock: errorBlock)
            }
            }.resume()
    }
    
    private func onDefaultResult(
        type: MediaType,
        data: Data?,
        response: URLResponse?,
        error: Error?,
        successBlock: @escaping () -> (),
        errorBlock: @escaping (Int?, String?) -> ()) {
        
        guard error == nil else {
            errorBlock(nil, error?.localizedDescription)
            return
        }
        
        if let httpStatus = response as? HTTPURLResponse,
            let statusCode = Constants.HTTPStatusCodes(rawValue: httpStatus.statusCode),
            statusCode != .ok {
            errorBlock(httpStatus.statusCode, "\(String(describing: response))")
        } else {
            guard let data = data,
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> else {
                    errorBlock(nil, "Couldn't parse response to JSON")
                    return
            }
            guard let fileURL = jsonResponse["url"] as? String else {
                errorBlock(nil, "Couldn't find \"url\" field in response")
                return
            }
            switch(type) {
            case .image:
                guard let screenName = DebuggIt.sharedInstance.report.currentScreenshotScreenName else { return }
                DebuggIt.sharedInstance.report.screenshots.append(Screenshot(screenName: screenName, url: fileURL))
            case .audio:
                DebuggIt.sharedInstance.report.audioUrls.append(fileURL)
            }
            successBlock()
        }
    }
}
