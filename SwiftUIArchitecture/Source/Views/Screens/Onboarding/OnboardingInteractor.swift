//
//  OnboardingInteractor.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

struct OnboardingInteractor {
    // MARK: - Constants

    let store: AppStore

    // MARK: - Variables <Computed>

    var validCharacters: CharacterSet {
        CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_")
    }

    var title: String {
        "Which Twitter hashtag do you want to follow?"
    }

    var placeholder: String {
        "swiftui"
    }

    // MARK: - Init

    init(store: AppStore) {
        self.store = store
    }

    // MARK: - Methods

    func done(_ text: String) {
        store.dispatch(AppAction.addHashtag(text))
        store.dispatch(RouteAction.setPath(.feed))
    }
}
