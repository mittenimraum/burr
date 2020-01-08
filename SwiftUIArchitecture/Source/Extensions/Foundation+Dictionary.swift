//
//  Foundation+Dictionary.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

struct KeyPath {
    var segments: [String]

    var isEmpty: Bool {
        return segments.isEmpty
    }

    var path: String {
        return segments.joined(separator: ".")
    }

    /// Strips off the first segment and returns a pair
    /// consisting of the first segment and the remaining key path.
    /// Returns nil if the key path has no segments.
    func headAndTail() -> (head: String, tail: KeyPath)? {
        guard !isEmpty else {
            return nil
        }
        var tail = segments
        let head = tail.removeFirst()

        return (head, KeyPath(segments: tail))
    }
}

/// Initializes a KeyPath with a string of the form "this.is.a.keypath"
extension KeyPath {
    init(_ string: String) {
        segments = string.components(separatedBy: ".")
    }
}

extension KeyPath: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(value)
    }

    init(unicodeScalarLiteral value: String) {
        self.init(value)
    }

    init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
}

extension Dictionary where Key: ExpressibleByStringLiteral {
    subscript(keyPath keyPath: KeyPath) -> Any? {
        get {
            switch keyPath.headAndTail() {
            case nil:
                // key path is empty.
                return nil
            case let (head, remainingKeyPath)? where remainingKeyPath.isEmpty:
                // Reached the end of the key path.
                guard let key = head as? Key else {
                    return nil
                }
                return self[key]
            case let (head, remainingKeyPath)?:
                // Key path has a tail we need to traverse.
                guard let key = head as? Key else {
                    return nil
                }
                switch self[key] {
                case let nestedDict as [Key: Any]:
                    // Next nest level is a dictionary.
                    // Start over with remaining key path.
                    return nestedDict[keyPath: remainingKeyPath]
                default:
                    // Next nest level isn't a dictionary.
                    // Invalid key path, abort.
                    return nil
                }
            }
        }
        set {
            switch keyPath.headAndTail() {
            case nil:
                // key path is empty.
                return
            case let (head, remainingKeyPath)? where remainingKeyPath.isEmpty:
                // Reached the end of the key path.
                guard let key = head as? Key else {
                    return
                }
                self[key] = newValue as? Value
            case let (head, remainingKeyPath)?:
                guard let key = head as? Key else {
                    return
                }
                let value = self[key]
                switch value {
                case var nestedDict as [Key: Any]:
                    // Key path has a tail we need to traverse
                    nestedDict[keyPath: remainingKeyPath] = newValue
                    self[key] = nestedDict as? Value
                default:
                    // Invalid keyPath
                    return
                }
            }
        }
    }
}

extension Dictionary where Key: ExpressibleByStringLiteral {
    subscript(string keyPath: KeyPath) -> String? {
        get {
            return self[keyPath: keyPath] as? String
        }
        set {
            self[keyPath: keyPath] = newValue
        }
    }

    subscript(dict keyPath: KeyPath) -> [Key: Any]? {
        get {
            return self[keyPath: keyPath] as? [Key: Any]
        }
        set {
            self[keyPath: keyPath] = newValue
        }
    }
}
