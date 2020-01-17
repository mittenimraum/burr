//
//  TwitterResponse.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

struct TwitterResponse: Codable {
    // MARK: - Enums

    enum CodingKeys: String, CodingKey {
        case metaData = "search_metadata"
        case statuses, errors

        enum MetaData: String, CodingKey {
            case nextResults = "next_results"
        }
    }

    // MARK: - Variables

    var statuses: [TwitterStatus]?
    var errors: [TwitterError]?
    var nextResults: String?

    // MARK: - Codable

    public init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: CodingKeys.self)
        statuses = try? root.decode([TwitterStatus].self, forKey: .statuses)
        errors = try? root.decode([TwitterError].self, forKey: .errors)

        if let metadata = try? root.nestedContainer(keyedBy: CodingKeys.MetaData.self, forKey: .metaData) {
            nextResults = try? metadata.decode(String.self, forKey: .nextResults)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var root = encoder.container(keyedBy: CodingKeys.self)
        var metadata = root.nestedContainer(keyedBy: CodingKeys.MetaData.self, forKey: .metaData)

        try? root.encode(statuses, forKey: .statuses)
        try? root.encode(errors, forKey: .errors)
        try? metadata.encodeOnlyIfNonNil(nextResults, forKey: .nextResults)
    }
}

extension TwitterResponse {
    var nextMaxId: String? {
        guard
            let nextResults = nextResults,
            let nextMaxId = nextResults
            .split(separator: "&")
            .map({ $0.split(separator: "=") })
            .filter({ $0.first?.contains(TwitterAPI.Parameters.maxId.rawValue) == true })
            .first?.last else {
            return nil
        }
        return String(nextMaxId)
    }
}
