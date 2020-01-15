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
    case search(query: String, Pagination)
}

// MARK: - Parameters / Headers

extension TwitterAPI {
    enum Parameters: String {
        case query = "q"
        case count
        case maxId = "max_id"
    }

    enum Headers: String {
        case authorization = "Authorization"
    }

    class Pagination {
        // MARK: - Variables

        var page: String?
        var size: Int

        // MARK: - Variables <Computed>

        var isAtStart: Bool {
            return page == nil
        }

        // MARK: - Init

        init(_ page: String? = nil, _ size: Int = 16) {
            self.page = page
            self.size = size
        }

        // MARK: - Methods <Convenience>

        @discardableResult
        func take(_ page: String?) -> Pagination {
            self.page = page

            return self
        }

        @discardableResult
        func start() -> Pagination {
            page = nil

            return self
        }
    }
}

// MARK: - Resource

extension TwitterAPI: Resource {
    var baseURL: URL {
        return URL(string: Credentials.shared.twitterAPIBaseURL)!
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
        case let .search(query, pagination):
            parameters[Parameters.count.rawValue] = pagination.size
            parameters[Parameters.query.rawValue] = "\(query) -RT" // without retweets

            if let page = pagination.page {
                parameters[Parameters.maxId.rawValue] = page
            }
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

extension TwitterAPI {
    static func urlString(mention: String) -> String? {
        return String(format: Credentials.shared.twitterUserURL, mention).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

    static func urlString(hashtag: String) -> String? {
        return String(format: Credentials.shared.twitterSearchURL, hashtag).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
