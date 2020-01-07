//
//  Routes.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 07.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

enum RoutePath {
    case root
    case onboarding
    case home
}

extension RoutePath: Equatable {
    var id: String {
        switch self {
        case .root: return "/"
        case .onboarding: return "/onboarding"
        case .home: return "/home"
        }
    }

    static func == (lhs: RoutePath, rhs: RoutePath) -> Bool {
        return lhs.id == rhs.id
    }
}
