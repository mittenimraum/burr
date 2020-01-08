//
//  FeedAction.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import CancelBag
import Combine
import Foundation
import Store
import SwiftUIRouter
import TinyNetworking

enum FeedAction: ActionProtocol, Networkable {
    // MARK: - Cases

    case fetch(term: String, TwitterAPI.Pagination, CancelBag)
    case refresh(term: String, TwitterAPI.Pagination, CancelBag)

    // MARK: - Identifier

    var id: String {
        switch self {
        case .fetch: return "FETCH"
        case .refresh: return "REFRESH"
        }
    }

    // MARK: - Reducer

    func reduce(context: TransactionContext<AppStore, Self>) {
        switch self {
        case let .fetch(term, pagination, bag):
            context.reduceModel {
                $0.feed.items = .fetching
            }
            request(context: context, term: term, pagination: pagination, bag: bag)
        case let .refresh(term, pagination, bag):
            context.reduceModel {
                $0.feed.items = .refreshing
            }
            request(context: context, term: term, pagination: pagination, bag: bag)
        }
    }

    private func request(context: TransactionContext<AppStore, Self>, term: String, pagination: TwitterAPI.Pagination, bag: CancelBag) {
        twitterAPI.requestPublisher(resource: .search(term: term, pagination), queue: .global(qos: .userInitiated))
            .tryMap { try $0.map(to: TwitterResponse.self) }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case let .failure(error):
                    context.reduceModel {
                        $0.feed.items = .error(error)
                    }

                default:
                    break
                }
                context.fulfill()
            }, receiveValue: { value in
                context.reduceModel {
                    guard let array = value.statuses else {
                        return
                    }
                    $0.feed.items = .success(array)
                }
                pagination.take(value.nextMaxId)
            })
            .cancel(with: bag)
    }
}
