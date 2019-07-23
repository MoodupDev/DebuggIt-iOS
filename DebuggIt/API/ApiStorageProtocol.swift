//
//  ApiStorageProtocol.swift
//  DebuggIt
//
//  Created by Piotr Gomoła on 23/07/2019.
//  Copyright © 2019 Mood Up. All rights reserved.
//

import Foundation

protocol ApiStorageProtocol {
    
    func upload(_ type: MediaType, data base64EncodedString: String, successBlock: @escaping () -> (), errorBlock: @escaping (_ statusCode: Int?, _ errorMessage: String?) -> ())
}

enum MediaType {
    case image
    case audio
}
