//
//  Obfuscator.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

struct Obfuscator {
    // MARK: - Variables

    let salt: String

    // MARK: - Init

    init(withSalt salt: [Any]) {
        self.salt = salt.description
    }

    // MARK: - XOR encryption

    func obfuscate(string: String) -> [UInt8] {
        let text = [UInt8](string.utf8)
        let cipher = [UInt8](salt.utf8)
        let length = cipher.count
        var encrypted = [UInt8]()

        for char in text.enumerated() {
            encrypted.append(char.element ^ cipher[char.offset % length])
        }
        return encrypted
    }

    func reveal(key: [UInt8]) -> String? {
        let cipher = [UInt8](salt.utf8)
        let length = cipher.count
        var decrypted = [UInt8]()

        for char in key.enumerated() {
            decrypted.append(char.element ^ cipher[char.offset % length])
        }
        return String(bytes: decrypted, encoding: .utf8)
    }
}
