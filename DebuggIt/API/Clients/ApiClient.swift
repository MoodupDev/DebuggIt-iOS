//
//  ApiClient.swift
//  DebuggIt
//
//  Created by Piotr Gomoła on 23/07/2019.
//  Copyright © 2019 Mood Up. All rights reserved.
//

import Foundation

class ApiClient: ApiStorageProtocol {
    
    private var url, imagePath, audioPath: String?
    private var uploadImage, uploadAudio: ((_ base64EncodedString: String) -> ())?
    
    init(url: String, imagePath: String, audioPath: String) {
        self.url = url
        self.imagePath = imagePath
        self.audioPath = audioPath
    }
    
    init(uploadImage: @escaping (_ base64EncodedString: String) -> (), uploadAudio: @escaping (_ base64EncodedString: String) -> ()) {
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
            request.httpBody = Data(base64Encoded: base64EncodedString, options: .ignoreUnknownCharacters)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    errorBlock(nil, error?.localizedDescription)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    errorBlock(httpStatus.statusCode, "\(response)")
                } else {
                    successBlock()
                }
            }
        } else {
            switch type {
            case .image:
                uploadImage?(base64EncodedString)
            case .audio:
                uploadAudio?(base64EncodedString)
            }
        }
    }
}
