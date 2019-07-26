//
//  ApiClient.swift
//  DebuggIt
//
//  Created by Piotr Gomoła on 23/07/2019.
//  Copyright © 2019 Mood Up. All rights reserved.
//

import Foundation

protocol UploadDelegate: AnyObject {
    func onSuccess(fileURL: String)
    func onError(code: Int?, message: String?)
}

class ApiClient: ApiStorageProtocol {
    
    private var url, imagePath, audioPath: String?
    
    private var uploadImage, uploadAudio: ((String, ApiClientDelegate) -> ())?
    
    init(url: String, imagePath: String, audioPath: String) {
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
            guard let url = self.url, let imagePath = self.imagePath, let audioPath = self.audioPath else { return }
            let endpoint = url + (type == .image ? imagePath : audioPath)
            
            guard let requestURL = URL(string: endpoint) else { return }
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
                    guard error == nil else {
                        errorBlock(nil, error?.localizedDescription)
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
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
                            let screenName = DebuggIt.sharedInstance.report.currentScreenshotScreenName!
                            DebuggIt.sharedInstance.report.screenshots.append(Screenshot(screenName: screenName, url: fileURL))
                        case .audio:
                            DebuggIt.sharedInstance.report.audioUrls.append(fileURL)
                        }
                        successBlock()
                    }
                }
            }.resume()
        } else {
            switch type {
            case .image:
                uploadImage?(base64EncodedString, ApiClientDelegate(onSuccess: { (fileURL) in
                    let screenName = DebuggIt.sharedInstance.report.currentScreenshotScreenName!
                    DebuggIt.sharedInstance.report.screenshots.append(Screenshot(screenName: screenName, url: fileURL))
                    successBlock()
                }, onError: { (code, message) in
                    errorBlock(code, message)
                }))
            case .audio:
                uploadAudio?(base64EncodedString, ApiClientDelegate(onSuccess: { (fileURL) in
                    DebuggIt.sharedInstance.report.audioUrls.append(fileURL)
                }, onError: { (code, message) in
                    errorBlock(code, message)
                }))
            }
        }
    }
}
