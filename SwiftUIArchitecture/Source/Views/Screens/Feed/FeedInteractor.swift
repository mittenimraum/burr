//
//  FeedInteractor.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import CancelBag
import Combine
import Foundation
import Store
import SwiftUI

class FeedInteractor: Networkable, ObservableObject {
    // MARK: - Constants

    let store: AppStore
    let term: String
    let storeBag: CancelBag = CancelBag()
    let actionBag: CancelBag = CancelBag()

    // MARK: - Variables

    @Published var dataSource: [TwitterStatus] = []

    var shouldLoadMore: Bool {
        if case .success = store.model.feed.items {
            return true
        }
        return false
    }

    // MARK: - Variables <Private>

    private var pagination = TwitterAPI.Pagination()

    // MARK: - Init

    init(store: AppStore, term: String) {
        self.store = store
        self.term = term
    }

    // MARK: - Actions

    func refresh() {
        store.run(action: FeedAction.refresh(term: term, pagination.start(), actionBag))
    }

    func fetch() {
        store.run(action: FeedAction.fetch(term: term, pagination, actionBag))
    }
}

extension FeedInteractor: StoreSubscriber {
    func newState(state: AppState) {
        switch state.feed.items {
        case .initial:
            break
        case .refreshing:
            break
        case .fetching:
            break
        case let .success(items):
            if pagination.isAtStart, dataSource != items {
                dataSource.removeAll()
            }
            items.forEach {
                guard self.dataSource.contains($0) == false else {
                    return
                }
                self.dataSource.append($0)
            }
        case let .error(error):
            debugPrint(error)
        }
    }
}
