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
    let l10nDuplicate = L10n.onboardingAddHashtagInputDuplicate

    // MARK: - Variables <Computed>

    var validCharacters: CharacterSet {
        CharacterSet(charactersIn: L10n.onboardingAddHashtagInputCharacters)
    }

    // MARK: - Init

    init(store: AppStore) {
        self.store = store
    }

    // MARK: - Methods

    func isDuplicate(_ hashtag: String) -> Bool {
        return account.hashtags?
            .map { $0.lowercased() }
            .contains(hashtag.lowercased()) == true
    }

    func done(_ text: String) {
        let currentPath = store.value.route.path

        if currentPath == .onboarding {
            store.dispatch(RouteAction.setPath(.feed))
        }
        DispatchQueue.delay(currentPath == .onboarding ? 0 : 0.33) {
            self.store.dispatch(AppAction.addHashtag(text))
            self.store.dispatch(AppAction.selectHashtag(text))
        }
    }
}
