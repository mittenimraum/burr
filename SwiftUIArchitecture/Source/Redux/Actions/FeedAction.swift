//
//  FeedAction.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Combine
import Foundation
import SwiftUIRouter
import TinyNetworking

enum FeedAction: Reducable, Networkable {
    // MARK: - Cases

    case fetch(term: String, TwitterAPI.Pagination, CancelBag)
    case refresh(term: String, TwitterAPI.Pagination, CancelBag)

    // MARK: - Reducer

    func reduce(store: AppStore) {
        switch self {
        case let .fetch(term, pagination, bag):
            store.reduce { state in
                state.feed.items = .fetching
            }
            request(store: store, term: term, pagination: pagination, bag: bag)
        case let .refresh(term, pagination, bag):
            store.reduce { state in
                state.feed.items = .refreshing
            }
            request(store: store, term: term, pagination: pagination, bag: bag)
        }
    }

    private func request(store: AppStore, term: String, pagination: TwitterAPI.Pagination, bag: CancelBag) {
        twitterAPI.requestPublisher(resource: .search(term: term, pagination), queue: .global(qos: .userInitiated))
            .tryMap { try $0.map(to: TwitterResponse.self) }
            .receive(on: DispatchQueue.main)
            .sinkToResult { result in
                switch result {
                case let .success(value):
                    store.reduce { state in
                        guard let array = value.statuses else {
                            return
                        }
                        state.feed.items = .success(array)
                    }
                    pagination.take(value.nextMaxId)
                case let .failure(error):
                    store.reduce { state in
                        state.feed.items = .error(error)
                    }
                }
            }
            .store(in: bag)
    }
}
