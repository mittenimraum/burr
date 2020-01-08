//
//  Foundation+Codable.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 11.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

extension KeyedEncodingContainer {
    public mutating func encodeOnlyIfNonNil<T>(_ value: T?, forKey key: KeyedEncodingContainer<K>.Key) throws where T: Encodable {
        if let value = value {
            try encode(value, forKey: key)
        }
    }
}

func archive<T: Encodable>(value: T) -> Data? {
    return try? PropertyListEncoder().encode(value)
}

func unarchive<T: Decodable>(data: Data, type _: T.Type) -> T? {
    return try? PropertyListDecoder().decode(T.self, from: data)
}
