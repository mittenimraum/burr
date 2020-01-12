//
//  Foundation+Dictionary.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

@dynamicMemberLookup
protocol DictionaryDynamicLookup {
    associatedtype Key
    associatedtype Value

    subscript(_: Key) -> Value? { get }
}

extension DictionaryDynamicLookup where Key == String {
    subscript<Result>(dynamicMember member: String) -> Result? {
        let value = self[member] as? Result
        return value
    }

    subscript(dynamicMember member: String) -> [String: Any]? {
        if let new = self[member] as? [String: Any] {
            return new
        }
        return nil
    }
}

extension Dictionary: DictionaryDynamicLookup {}
