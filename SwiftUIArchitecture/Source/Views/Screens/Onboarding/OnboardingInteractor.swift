//
//  OnboardingInteractor.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

struct OnboardingInteractor: Accountable {
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

    func isValid(_ hashtag: String) -> Bool {
        return accountService.hashtags?.contains(hashtag) == false
    }

    func done(_ text: String) {
        store.dispatch(RouteAction.setPath(.feed))

        DispatchQueue.next {
            self.store.dispatch(AppAction.addHashtag(text))
            self.store.dispatch(AppAction.selectHashtag(text))
        }
    }
}
