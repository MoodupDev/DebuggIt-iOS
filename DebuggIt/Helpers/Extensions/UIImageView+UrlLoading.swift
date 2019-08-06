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
    func loadFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        self.contentMode = mode
        if let cachedImage = ImageCache.shared.image(forKey: url) {
            self.image = cachedImage
        } else {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() { () -> Void in
                    ImageCache.shared.put(image: image, forKey: url)
                    self.image = image
                }
                }.resume()
        }
    }
    
    func loadFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        loadFrom(url: url, contentMode: mode)
    }
}
