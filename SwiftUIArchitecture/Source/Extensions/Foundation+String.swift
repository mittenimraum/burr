//
//  Foundation+String.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var fileName: String? {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    var fileExtension: String? {
        return URL(fileURLWithPath: self).pathExtension
    }

    var isHashtag: Bool {
        let regularExpression = "(#[a-zA-Z0-9_\\p{Arabic}\\p{N}]*)"
        return NSPredicate(format: "SELF MATCHES %@", regularExpression).evaluate(with: self)
    }
}

extension String {
    /// Generates a `UIImage` instance from this string using a specified
    /// attributes and size.
    ///
    /// - Parameters:
    ///     - attributes: to draw this string with. Default is `nil`.
    ///     - size: of the image to return.
    /// - Returns: a `UIImage` instance from this string using a specified
    /// attributes and size, or `nil` if the operation fails.
    func image(withAttributes attributes: [NSAttributedString.Key: Any]? = nil, size: CGSize? = nil) -> UIImage {
        let size = size ?? (self as NSString).size(withAttributes: attributes)
        return UIGraphicsImageRenderer(size: size).image { _ in
            (self as NSString).draw(in: CGRect(origin: .zero, size: size), withAttributes: attributes)
        }
    }
}
