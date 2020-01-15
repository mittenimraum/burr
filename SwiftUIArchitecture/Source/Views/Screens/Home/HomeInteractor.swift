//
//  HomeInteractor.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Combine
import Foundation

class HomeInteractor: ObservableObject {
    // MARK: - Constants

    let store: AppStore
    let storeBag = CancelBag()
    let selected = Observable<Int>(0)

    // MARK: - Variables

    @Published var hashtags: [String] = []

    // MARK: - Init

    init(store: AppStore) {
        self.store = store
    }
}

extension HomeInteractor: StoreSubscriber {
    func subscribe() {
        subscribe(to: \.self)
    }

    func newState(value: AppState) {
        if hashtags != value.hashtags {
            hashtags = value.hashtags
        }
        if selected.value != value.selected {
            selected.value = value.selected
        }
    }
}
