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
    let hashtag: String
    let storeBag: CancelBag = CancelBag()
    let actionBag: CancelBag = CancelBag()
    let url: Observable<URL?> = Observable(nil)

    // MARK: - Constants <Localization>

    let l10nYes = L10n.generalYes
    let l10nNo = L10n.generalNo

    // MARK: - Variables <Localization>

    var l10nRemoveText: String { L10n.generalDeleteText(title) }

    // MARK: - Variables <Published>

    @Published var status: ListStatus<[FeedItem]> = .initial

    // MARK: - Variables <Computed>

    var shouldLoadMore: Bool {
        if case .success = store.value.feed.items[hashtag] {
            return true
        }
        return false
    }

    var shouldShowRemove: Bool {
        return store.value.hashtags.count > 1
    }

    var title: String {
        return "#\(hashtag)"
    }

    // MARK: - Variables <Private>

    private var pagination = TwitterAPI.Pagination()

    // MARK: - Init

    init(store: AppStore, hashtag: String) {
        self.store = store
        self.hashtag = hashtag
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
        return previousItems.map {
            FeedItem(
                status: $0,
                timer: Domain.timer,
                open: open()
            )
        }
    }

    // MARK: - Actions

    func remove() {
        store.dispatch(AppAction.removeHashtag(hashtag))
    }

    func refresh() {
        store.dispatch(FeedAction.refresh(hashtag: hashtag, pagination.start(), actionBag))
    }

    func fetch() {
        store.dispatch(FeedAction.fetch(hashtag: hashtag, pagination, actionBag))
    }

    func select() {
        store.dispatch(AppAction.selectHashtag(hashtag))
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
        switch value.items[hashtag] {
        case let .success(items):
            status = .success(data(for: items))
        case let .error(error):
            status = .error(error)
        default:
            break
        }
    }
}
