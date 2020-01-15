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

class FeedInteractor: ObservableObject {
    // MARK: - Constants

    let store: AppStore
    let term: String
    let storeBag: CancelBag = CancelBag()
    let actionBag: CancelBag = CancelBag()

    // MARK: - Variables

    var url: Observable<URL?> = Observable(nil)

    // MARK: - Variables <Published>

    @Published var status: ListStatus<[FeedItem]> = .initial

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

    // MARK: - DataSource

    func data(for items: [TwitterStatus]) -> [FeedItem] {
        var previousItems = status.value?.compactMap { $0.status } ?? []

        if pagination.isAtStart, previousItems != items {
            previousItems = []
        }
        items.forEach {
            guard previousItems.contains($0) == false else {
                return
            }
            previousItems.append($0)
        }
        return previousItems.map { FeedItem(status: $0, open: open()) }
    }

    // MARK: - Actions

    func refresh() {
        store.dispatch(FeedAction.refresh(term: term, pagination.start(), actionBag))
    }

    func fetch() {
        store.dispatch(FeedAction.fetch(term: term, pagination, actionBag))
    }

    func open() -> Action<String> {
        return Action { [weak self] value in
            self?.url.value = URL(string: value)
        }
    }
}

// MARK: - StoreSubscriber

extension FeedInteractor: StoreSubscriber {
    func subscribe() {
        subscribe(to: \.feed)
    }

    func newState(value: FeedState) {
        switch value.items {
        case let .success(items):
            status = .success(data(for: items))
        case let .error(error):
            status = .error(error)
        default:
            break
        }
    }
}
