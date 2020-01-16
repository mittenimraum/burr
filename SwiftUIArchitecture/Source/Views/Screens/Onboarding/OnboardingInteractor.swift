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

    // MARK: - Constants <Localization>

    let l10nTitle = L10n.onboardingAddHashtagTitle
    let l10nPlaceholder = L10n.onboardingAddHashtagInputPlaceholder
    let l10nHighlightedCharacters = L10n.onboardingAddHashtagTitleHighlighted

    // MARK: - Variables <Computed>

    var validCharacters: CharacterSet {
        CharacterSet(charactersIn: L10n.onboardingAddHashtagInputCharacters)
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
