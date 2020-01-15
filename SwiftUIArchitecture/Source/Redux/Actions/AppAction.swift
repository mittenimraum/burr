//
//  AppAction.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 07.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

enum AppAction: Reducable, Accountable {
    case addHashtag(String)
    case setHashtags([String])

    func reduce(store: AppStore) {
        switch self {
        case let .addHashtag(hashtag):
            let hashtags = accountService.addHashtag(hashtag)

            store.reduce { state in
                state.hashtags = hashtags
            }
        case let .setHashtags(hashtags):
            accountService.hashtags = hashtags

            store.reduce { state in
                state.hashtags = hashtags
            }
        }
    }
}
