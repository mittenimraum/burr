//
//  Credentials.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

class Credentials: Configuration {
    // MARK: - Constants

    static let shared = Credentials()

    // MARK: - Variables

    override var file: String {
        return "Credentials.enc"
    }

    override var encryption: Encryption {
        guard let key = Obfuscator(withSalt: CredentialsSalt).reveal(key: CredentialsKey) else {
            fatalError("Couldn't reveal obfuscated encryption key for credentials")
        }
        return .AES128(key)
    }

    var twitterBaseURL: String {
        return self[\.Twitter!.BaseURL!]
    }

    var twitterApiKey: String {
        return self[\.Twitter!.APIKey!]
    }

    var twitterApiKeySecret: String {
        return self[\.Twitter!.APIKeySecret!]
    }

    var twitterAccessToken: String {
        return self[\.Twitter!.AccessToken!]
    }

    var twitterAccessTokenSecret: String {
        return self[\.Twitter!.AccessTokenSecret!]
    }
}
