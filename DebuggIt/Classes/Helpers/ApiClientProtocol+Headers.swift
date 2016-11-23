//
//  ApiClientProtocol+Headers.swift
//  DebuggIt
//
//  Created by Arkadiusz Żmudzin on 26.10.2016.
//  Copyright © 2016 Mood Up. All rights reserved.
//

extension ApiClientProtocol {
    
    func authorizationHeader(username: String, password: String) -> String {
        let basicToken = "\(username):\(password)".toBase64()
        return "Basic \(basicToken)"
    }
    
    func authorizationHeader(prefix: String = "Bearer", token: String) -> String {
        return "\(prefix) \(token)"
    }
}
