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
    let recorder = AppRecorder()

    // MARK: - Init

    init(_ value: AppState) {
        let state = recorder.read { $0.feed.items = [:] } ?? value
        let store = AppStore(state)

        self.store = store
        router = Router(content: { RouterView(store: store, RootView()) })

        initializeStyling()
        initializeRecorder()
        initializeDefaults()
    }

    private func initializeStyling() {
        Interface.applyStyling()
    }

    private func initializeRecorder() {
        recorder.observe(store)
    }

    private func initializeDefaults() {
        let hashtags = Domain.accountService.hashtags ?? []
        store.dispatch(AppAction.setHashtags(hashtags))
        store.dispatch(RouteAction.setPath(hashtags.isEmpty ? .onboarding : .feed))
    }
}
