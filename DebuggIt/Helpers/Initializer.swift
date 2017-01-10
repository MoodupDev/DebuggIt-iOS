//
//  Initializer.swift
//  Pods
//
//  Created by Arkadiusz Żmudzin on 25.11.2016.
//
//

import Foundation
import UIKit

class Initializer {
    
    static func bundle(forClass: AnyClass) -> Bundle {
        return Bundle(for: forClass)
    }

    static func viewController<T: UIViewController>(_ withClass: T.Type) -> T {
        return withClass.init(nibName: String(describing: withClass), bundle: bundle(forClass: withClass))
    }
    
    static func view<T: UIView>(_ withClass: T.Type, owner: Any? = nil) -> UIView {
        return nib(named: String(describing: withClass)).instantiate(withOwner: owner, options: nil)[0] as! UIView
    }
    
    static func image(named: String) -> UIImage {
        return UIImage(named: named, in: bundle(forClass: DebuggIt.self), compatibleWith: nil)!
    }
    
    static func nib(named: String) -> UINib {
        return UINib(nibName: named, bundle: bundle(forClass: DebuggIt.self))
    }
}
