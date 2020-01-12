//
//  Configuration.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import CryptoSwift
import Foundation
import UIKit

class Configuration {
    // MARK: - Enums

    enum Encryption {
        case none
        case AES128(String)
    }

    // MARK: - Variables

    var file: String {
        fatalError("Configuration.configurationFile should be overriden by a subclass")
    }

    var dictionary: [String: Any]?
    var encryption: Encryption {
        return .none
    }

    // MARK: - Init

    init() {
        loadDictionary()
    }

    private func loadDictionary() {
        guard
            let path = pathFor(configurationFile: file),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return
        }
        dictionary = decrypt(data: data, encryption: encryption)
    }

    // MARK: - Util

    subscript<T>(keypath: KeyPath<[String: Any], T>) -> T {
        guard let value = dictionary?[keyPath: keypath] else {
            fatalError("Didn't find value for \(keypath)")
        }
        return value
    }

    func pathFor(configurationFile: String) -> String? {
        let fileName = configurationFile.fileName
        let fileType = configurationFile.fileExtension

        return Bundle.main.path(forResource: fileName, ofType: fileType)
    }

    // MARK: - Encryption

    private func decrypt(data: Data, encryption: Encryption) -> [String: AnyObject]? {
        switch encryption {
        case .none:
            var propertyListFormat = PropertyListSerialization.PropertyListFormat.xml

            do {
                return try PropertyListSerialization.propertyList(
                    from: data,
                    options: .mutableContainersAndLeaves,
                    format: &propertyListFormat
                ) as? [String: AnyObject]
            } catch {
                print("Error reading plist: \(error), format: \(propertyListFormat)")
            }
            return nil
        case let .AES128(key):
            let decryptionKey = Array(key.utf8).md5()

            do {
                let decryptionCipher = try AES(
                    key: decryptionKey,
                    blockMode: CBC(iv: [UInt8](repeating: 0, count: 16)),
                    padding: .pkcs7
                )
                let decryptedData = try data.decrypt(cipher: decryptionCipher)

                return decrypt(data: decryptedData, encryption: .none)
            } catch {
                debugPrint(error.localizedDescription)
            }
            return nil
        }
    }
}
