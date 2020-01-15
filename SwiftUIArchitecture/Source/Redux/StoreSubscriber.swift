//
//  StoreSubscriber.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Combine
import Foundation

protocol StoreSubscriber {
    associatedtype StoreValue: Equatable

    var store: AppStore { get }
    var storeBag: CancelBag { get }

    func newState(value: StoreValue)
    func subscribe()
    func unsubscribe()
}

extension StoreSubscriber {
    func subscribe<Value>(to keyPath: KeyPath<AppState, Value>) where Value: Equatable {
        store
            .subscribe(for: keyPath).sink { result in
                guard let value = result as? StoreValue else {
                    return
                }
                self.newState(value: value)
            }
            .store(in: storeBag)
    }

    func unsubscribe() {
        storeBag.cancelAll()
    }
}
