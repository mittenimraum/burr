//
//  Store.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 12.01.20.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

// MARK: - Store

typealias Store<State> = CurrentValueSubject<State, Never>

extension CurrentValueSubject {
    subscript<T>(keyPath: WritableKeyPath<Output, T>) -> T where T: Equatable {
        get {
            value[keyPath: keyPath]
        }
        set {
            var value = self.value

            if value[keyPath: keyPath] != newValue {
                value[keyPath: keyPath] = newValue
                self.value = value
            }
        }
    }

    func reduce(_ update: (inout Output) -> Void) {
        var value = self.value
        update(&value)
        self.value = value
    }

    func subscribe<Value>(for keyPath: KeyPath<Output, Value>) -> AnyPublisher<Value, Failure> where Value: Equatable {
        return map(keyPath).removeDuplicates().eraseToAnyPublisher()
    }
}

extension Subscribers.Completion {
    var error: Failure? {
        switch self {
        case let .failure(error): return error
        default: return nil
        }
    }
}

extension Publisher {
    func sinkToResult(_ result: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                result(.failure(error))
            default: break
            }
        }, receiveValue: { value in
            result(.success(value))
        })
    }

    func extractUnderlyingError() -> Publishers.MapError<Self, Failure> {
        mapError {
            (($0 as NSError).userInfo[NSUnderlyingErrorKey] as? Failure) ?? $0
        }
    }
}

extension Binding where Value: Equatable {
    func dispatched<State>(to state: Store<State>, _ keyPath: WritableKeyPath<State, Value>) -> Self {
        return .init(get: { () -> Value in
            self.wrappedValue
        }, set: { value in
            self.wrappedValue = value
            state[keyPath] = value
        })
    }
}

// MARK: - Cancellation

class CancelBag {
    var subscriptions = Set<AnyCancellable>()

    func cancelAll() {
        subscriptions.forEach { $0.cancel() }
    }
}

extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}

// MARK: - Disposable

protocol Disposable {
    mutating func dispose()
}
