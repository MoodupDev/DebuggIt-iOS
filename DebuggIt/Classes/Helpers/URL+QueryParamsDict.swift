//
//  String+IndexOf.swift
//  DebugIt
//
//  Created by Arkadiusz Żmudzin on 18.11.2016.
//  Copyright © 2016 MoodUp. All rights reserved.
//
import Foundation

extension URL {
    func queryParams() -> [String : String] {
        var params = [String: String]()
        let url = URL(string: self.absoluteString.replaceFirst(replace: "#", with: "?"))!
        url.query?.components(separatedBy: "&").forEach({ (param) in
            let components = param.components(separatedBy: "=")
            params[components[0]] = components[1]
        })
        return params
    }
}
