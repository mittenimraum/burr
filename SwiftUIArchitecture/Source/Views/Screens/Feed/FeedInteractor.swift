//
//  FeedInteractor.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

protocol FeedInteractable {
    var store: AppStore { get }
}

struct FeedInteractor: FeedInteractable {
    let store: AppStore

    init(store: AppStore) {
        self.store = store
    }
}
