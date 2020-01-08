//
//  Routes.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 07.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

enum RoutePath: String {
    case root
    case onboarding
    case feed

    init?(id: String) {
        switch id {
        case RoutePath.root.id: self = .root
        case RoutePath.onboarding.id: self = .onboarding
        case RoutePath.feed.id: self = .feed
        default: return nil
        }
    }
}

extension RoutePath: Equatable {
    var id: String {
        switch self {
        case .root: return "/"
        case .onboarding: return "/onboarding"
        case .feed: return "/feed"
        }
    }

    static func == (lhs: RoutePath, rhs: RoutePath) -> Bool {
        return lhs.id == rhs.id
    }
}
