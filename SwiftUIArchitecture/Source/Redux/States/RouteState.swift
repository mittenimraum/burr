//
//  RouteState.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 07.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import SwiftUIRouter

struct RouteState {
    // MARK: - Variables

    var path: RoutePath = .onboarding
    var history: HistoryData?
}

extension RouteState: Codable {
    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case path
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let path = try container.decode(String.self, forKey: .path)

        self.path = RoutePath(rawValue: path) ?? .onboarding
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try? container.encode(path.rawValue, forKey: .path)
    }
}

extension RouteState: Equatable {
    static func == (lhs: RouteState, rhs: RouteState) -> Bool {
        return lhs.path == rhs.path
    }
}
