//
//  RouterView.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 07.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Combine
import SwiftUI
import SwiftUIRouter

// MARK: - RootView

struct RouterView<Content: View>: View {
    // MARK: - Constants

    private let content: Content
    private let store: AppStore

    // MARK: - Variables <Private>

    @EnvironmentObject private var history: HistoryData
    private var bag = CancelBag()

    // MARK: - Init

    public init(store: AppStore, _ content: Content) {
        self.store = store
        self.content = content
    }

    // MARK: - Body

    var body: some View {
        content
            .onAppear {
                self.history.objectWillChange.sink { _ in
                    DispatchQueue.next {
                        guard let path = RoutePath(id: self.history.path) else {
                            return
                        }
                        RouteAction.setPath(path).reduce(store: self.store)
                    }
                }.store(in: self.bag)
                RouteAction.setHistory(self.history).reduce(store: self.store)
                RouteAction.setPath(self.store.value.route.path).reduce(store: self.store)
            }
            .modifier(StoreContainer.Injector(container: StoreContainer(store: store)))
    }
}
