//
//  RouteAction.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 07.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation
import SwiftUIRouter

enum RouteAction {
    // MARK: - Cases

    case setPath(RoutePath)
    case setHistory(HistoryData)

    // MARK: - Identifier

    var id: String {
        switch self {
        case .setPath: return "SET_PATH"
        case .setHistory: return "SET_HISTORY"
        }
    }

    // MARK: - Reducer

    func reduce(store: AppStore) {
        switch self {
        case let .setPath(path):
            store.reduce {
                $0.route.path = path
                $0.route.history?.go(path.id)
            }
        case let .setHistory(history):
            store.reduce {
                $0.route.history = history
            }
        }
    }
}
