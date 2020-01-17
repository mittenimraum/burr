//
//  TwitterError.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 17.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

struct TwitterError: Codable {
    var code: Int?
    var message: String?
}

extension TwitterError {
    var unwrappedMessage: String {
        message ?? L10n.errorUnknown
    }

    var formattedMessage: String? {
        switch code {
        case 88?:
            return L10n.errorRateLimitExceeded
        default:
            return message
        }
    }
}

extension TwitterError {
    static var noResults: Self {
        return TwitterError(code: 0, message: L10n.errorFeedNoData)
    }
}
