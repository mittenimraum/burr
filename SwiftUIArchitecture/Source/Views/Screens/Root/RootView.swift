//
//  RootView.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 07.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Store
import SwiftUI
import SwiftUIRouter

// MARK: - RootView

struct RootView: View {
    // MARK: - Variables <Private>

    @Environment(\.container) private var container: StoreContainer

    // MARK: - Variables

    var body: some View {
        Switch {
            Route(path: RoutePath.onboarding.id) { _ in
                onboardingPresenter(self.container.store)
                    .transition(.opacity)
            }
            Route(path: RoutePath.feed.id) { _ in
                homePresenter(self.container.store)
                    .transition(.opacity)
            }
        }
    }
}

// MARK: - RootView_Previews

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
