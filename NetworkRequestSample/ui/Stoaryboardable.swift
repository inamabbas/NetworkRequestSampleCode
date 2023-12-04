//
//  Stoaryboardable.swift
//  NetworkRequestSample
//
//  Created by Inam Abbas on 04.12.23.
//

import UIKit

// If you want to use storboard to instantiate your view controller, use the protocol

protocol StoryboardInstantiable: AnyObject {
    static var storyboardName: String { get }
    static var storyboardIdentifier: String { get }
    func instantiate() -> UIViewController
}

extension StoryboardInstantiable where Self: UIViewController {
    static var storyboardname : String { return "Main" }
    static var storyboardIdentifier: String { return String(describing: self) }
}
