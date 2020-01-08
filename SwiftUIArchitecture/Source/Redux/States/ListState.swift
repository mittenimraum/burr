//
//  ListState.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 11.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

enum ListStatus<T> {
    case initial
    case refreshing
    case fetching
    case success(T)
    case error(Error)

    var id: String {
        switch self {
        case .initial: return "initial"
        case .refreshing: return "refreshing"
        case .fetching: return "fetching"
        case .success: return "success"
        case .error: return "error"
        }
    }

    init(id: String) {
        switch id {
        case "refreshing": self = .refreshing
        case "fetching": self = .fetching
        default:
            self = .initial
        }
    }

    init(id _: String, items: T) {
        self = .success(items)
    }

    init(id _: String, error: Error) {
        self = .error(error)
    }
}

enum ListError: Error {
    case restored(String)
}

extension ListStatus: Codable where T: Codable {
    enum CodingKeys: CodingKey {
        case id, items, error
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)

        if let items = try? container.decode(T.self, forKey: .items) {
            self = ListStatus(id: id, items: items)
        } else if let error = try? container.decode(String.self, forKey: .error) {
            self = ListStatus(id: id, error: ListError.restored(error))
        } else {
            self = ListStatus(id: id)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)

        if case let .success(items) = self {
            try? container.encode(items, forKey: .items)
        }
        if case let .error(error) = self {
            try? container.encode(error.localizedDescription, forKey: .error)
        }
    }
}

protocol ListState {
    associatedtype ItemType

    var status: ListStatus<ItemType> { get set }
}

extension ListStatus: Equatable where T: Equatable {
    static func == (lhs: ListStatus<T>, rhs: ListStatus<T>) -> Bool {
        switch (lhs, rhs) {
        case let (.success(lhsResponse), .success(rhsResponse)):
            return lhsResponse == rhsResponse
        case let (.error(lhsError), .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.initial, .initial):
            return true
        case (.refreshing, .refreshing):
            return true
        case (.fetching, .fetching):
            return true
        default:
            return false
        }
    }
}
