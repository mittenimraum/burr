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

    case fetch(hashtag: String, TwitterAPI.Pagination, CancelBag)
    case refresh(hashtag: String, TwitterAPI.Pagination, CancelBag)

    // MARK: - Reducer

    func reduce(store: AppStore) {
        switch self {
        case let .fetch(hashtag, pagination, bag):
            store.reduce { state in
                state.feed.items[hashtag] = .fetching
            }
            request(store: store, hashtag: hashtag, pagination: pagination, bag: bag)
        case let .refresh(hashtag, pagination, bag):
            store.reduce { state in
                state.feed.items[hashtag] = .refreshing
            }
            request(store: store, hashtag: hashtag, pagination: pagination, bag: bag)
        }
    }

    private func request(store: AppStore, hashtag: String, pagination: TwitterAPI.Pagination, bag: CancelBag) {
        twitterAPI.requestPublisher(resource: .search(query: "#\(hashtag)", pagination), queue: .global(qos: .userInitiated))
            .tryMap { try $0.map(to: TwitterResponse.self) }
            .receive(on: DispatchQueue.main)
            .sinkToResult { result in
                switch result {
                case let .success(value):
                    store.reduce { state in
                        guard let array = value.statuses else {
                            return
                        }
                        state.feed.items[hashtag] = .success(array)
                    }
                    pagination.take(value.nextMaxId)
                case let .failure(error):
                    store.reduce { state in
                        state.feed.items[hashtag] = .error(error)
                    }
                }
            }
            .store(in: bag)
    }
}
