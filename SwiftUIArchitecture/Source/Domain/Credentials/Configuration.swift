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

    var encryption: Encryption {
        return .none
    }

    var dictionary: [String: AnyObject]?

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

    func stringForKey(_ key: String) -> String {
        guard let value = dictionary?[keyPath: KeyPath(key)] as? String else {
            debugPrint(self, "stringForKey didn't find key: ", key)
            return ""
        }
        return value
    }

    func boolForKey(_ key: String) -> Bool {
        guard let value = dictionary?[keyPath: KeyPath(key)] as? Bool else {
            debugPrint(self, "boolForKey didn't find key: ", key)
            return false
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
