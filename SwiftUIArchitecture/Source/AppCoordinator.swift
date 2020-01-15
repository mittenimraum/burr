//
//  AppCoordinator.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 07.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation
import SwiftUIRouter

// MARK: - AppCoordinator

class AppCoordinator {
    // MARK: - Constants

    let store: AppStore
    let router: AppRouter

    // MARK: - Init

    init(_ state: AppState) {
        store = AppStore(state)
        let routerView = RouterView(store: store, RootView())
        router = Router(content: { routerView })

        initializeStyling()
        initializeDefaults()
    }

    private func initializeStyling() {
        Interface.applyStyling()
    }

    private func initializeDefaults() {
        let hashtags = Domain.accountService.hashtags ?? []
        store.dispatch(AppAction.setHashtags(hashtags))
        store.dispatch(RouteAction.setPath(hashtags.isEmpty ? .onboarding : .feed))
    }
}
