//
//  Credentials.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

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
        return stringForKey("Twitter.BaseURL")
    }

    var twitterApiKey: String {
        return stringForKey("Twitter.APIKey")
    }

    var twitterApiKeySecret: String {
        return stringForKey("Twitter.APIKeySecret")
    }

    var twitterAccessToken: String {
        return stringForKey("Twitter.AccessToken")
    }

    var twitterAccessTokenSecret: String {
        return stringForKey("Twitter.AccessTokenSecret")
    }
}
