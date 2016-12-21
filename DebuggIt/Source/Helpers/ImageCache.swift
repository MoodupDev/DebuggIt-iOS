//
//  ImageCache.swift
//  Pods
//
//  Created by Arkadiusz Żmudzin on 21.12.2016.
//
//


import Foundation
import UIKit

class ImageCache {
    
    static let shared = ImageCache()
    
    private var cache: NSCache<NSString, UIImage>
    
    func image(forKey url: URL) -> UIImage? {
        return image(forKey: url.absoluteString)
    }
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func put(image: UIImage, forKey url: URL) {
        self.put(image: image, forKey: url.absoluteString)
    }
    
    func put(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func clearAll() {
        cache.removeAllObjects()
    }
    
    func clear(key url: URL) {
        self.clear(key: url.absoluteString)
    }
    
    func clear(key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    private init() {
        self.cache = NSCache<NSString, UIImage>()
    }
}
