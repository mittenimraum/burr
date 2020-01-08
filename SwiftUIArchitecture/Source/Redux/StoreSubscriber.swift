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
    var store: AppStore { get }
    var storeBag: CancelBag { get }

    func newState(state: AppState)
    func subscribe()
    func unsubscribe()
}

extension StoreSubscriber {
    func subscribe() {
        store.$model
            .sink { value in
                self.newState(state: value)
            }
            .cancel(with: storeBag)
    }

    func unsubscribe() {
        storeBag.cancel()
    }
}
