//
//  FeedInteractor.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class FeedInteractor: Networkable, ObservableObject {
    // MARK: - Constants

    let store: AppStore
    let term: String
    let storeBag: CancelBag = CancelBag()
    let actionBag: CancelBag = CancelBag()

    // MARK: - Variables

    @Published var status: ListStatus<[TwitterStatus]> = .initial

    // MARK: - Variables <Computed>

    var shouldLoadMore: Bool {
        if case .success = store.value.feed.items {
            return true
        }
        return false
    }

    var title: String {
        return "#\(term)"
    }

    // MARK: - Variables <Private>

    private var pagination = TwitterAPI.Pagination()

    // MARK: - Init

    init(store: AppStore, term: String) {
        self.store = store
        self.term = term

        fetch()
    }

    // MARK: - Actions

    func refresh() {
        FeedAction.refresh(term: term, pagination.start(), actionBag).reduce(store: store)
    }

    func fetch() {
        FeedAction.fetch(term: term, pagination, actionBag).reduce(store: store)
    }
}

extension FeedInteractor: StoreSubscriber {
    func subscribe() {
        subscribe(to: \.feed)
    }

    func newState(state: FeedState) {
        switch state.items {
        case let .success(items):
            var previousItems = status.value ?? []

            if pagination.isAtStart, previousItems != items {
                previousItems = []
            }
            items.forEach {
                guard previousItems.contains($0) == false else {
                    return
                }
                previousItems.append($0)
            }
            status = .success(previousItems)

        case let .error(error):
            status = .error(error)
        default:
            break
        }
    }
}
