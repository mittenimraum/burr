//
//  StoreSubscriber.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import CancelBag
import Combine
import Foundation
import Store

protocol StoreSubscriber {
    associatedtype StateType: Equatable

    var store: AppStore { get }
    var storeBag: CancelBag { get }

    func newState(state: StateType)
    func subscribe()
    func unsubscribe()
}

extension StoreSubscriber {
    func subscribe<Value>(to keyPath: KeyPath<AppState, Value>) where Value: Equatable {
        store
            .subscribe(for: keyPath).sink { state in
                guard let state = state as? StateType else {
                    return
                }
                self.newState(state: state)
            }
            .store(in: storeBag)
    }

    func unsubscribe() {
        storeBag.cancelAll()
    }
}
