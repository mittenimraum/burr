//
//  TwitterUser.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 16.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

struct TwitterUser: Codable, Identifiable, Hashable {
    // MARK: - Enums

    enum CodingKeys: String, CodingKey {
        case id, name
        case username = "screen_name"
    }

    // MARK: - Variables

    var id: Int?
    var name: String?
    var username: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension TwitterUser {
    var formattedUsername: String? {
        guard let username = username else {
            return nil
        }
        return "@\(username)"
    }
}
