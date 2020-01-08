//
//  TwitterAPI.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation
import OhhAuth
import TinyNetworking

// MARK: - TwitterAPI

enum TwitterAPI {
    case search(term: String)
}

// MARK: - Parameters / Headers

extension TwitterAPI {
    enum Parameters: String {
        case term = "q"
    }

    enum Headers: String {
        case authorization = "Authorization"
    }
}

// MARK: - Resource

extension TwitterAPI: Resource {
    var baseURL: URL {
        return URL(string: Credentials.shared.twitterBaseURL)!
    }

    var endpoint: Endpoint {
        switch self {
        case .search:
            return .get(path: "/search/tweets.json")
        }
    }

    var task: Task {
        var parameters: [String: Any] = [:]

        switch self {
        case let .search(term):
            parameters[Parameters.term.rawValue] = term
        }
        return .requestWithParameters(parameters, encoding: URLEncoding())
    }

    var headers: [String: String] {
        guard let headers = oAuthHeader else {
            return [:]
        }
        return headers
    }

    var cachePolicy: URLRequest.CachePolicy {
        return .useProtocolCachePolicy
    }
}

// MARK: - OAuth

extension TwitterAPI {
    var oAuthHeader: [String: String]? {
        let consumerCredentials = OhhAuth.Credentials(
            key: Credentials.shared.twitterApiKey,
            secret: Credentials.shared.twitterApiKeySecret
        )
        let userCredentials = OhhAuth.Credentials(
            key: Credentials.shared.twitterAccessToken,
            secret: Credentials.shared.twitterAccessTokenSecret
        )
        var request = URLRequest(url: endpointURL)
        request.oAuthSign(
            method: endpointMethod,
            urlFormParameters: endpointParameters,
            consumerCredentials: consumerCredentials,
            userCredentials: userCredentials
        )
        return request.allHTTPHeaderFields?.filter { $0.key == Headers.authorization.rawValue }
    }
}
