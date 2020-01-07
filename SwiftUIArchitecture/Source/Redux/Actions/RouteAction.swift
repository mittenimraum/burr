//
//  RouteAction.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 07.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation
import Store
import SwiftUIRouter

enum RouteAction: ActionProtocol {
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

    func reduce(context: TransactionContext<AppStore, Self>) {
        defer {
            context.fulfill()
        }
        switch self {
        case let .setPath(path):
            context.reduceModel {
                $0.route.path = path
                $0.route.history?.go(path.id)
            }
        case let .setHistory(history):
            context.reduceModel {
                $0.route.history = history
            }
        }
    }
}
