//
//  UIImageView+UrlLoading.swift
//  DebugIt
//
//  Created by Bartek on 10/11/16.
//  Copyright © 2016 MoodUp. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    
    func LoadFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        loadFrom(url: url, contentMode: mode)
    }
}
