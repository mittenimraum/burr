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
    case selectHashtag(String)
    case selectIndex(Int)
    case removeHashtag(String)

    func reduce(store: AppStore) {
        switch self {
        case let .selectIndex(index):
            store.reduce { state in
                state.selected = index
            }
        case let .selectHashtag(hashtag):
            guard let index = accountService.hashtags?.firstIndex(of: hashtag) else {
                return
            }
            store.reduce { state in
                state.selected = index
            }
        case let .removeHashtag(hashtag):
            let hashtags = accountService.remove(hashtag: hashtag)

            store.reduce { state in
                state.hashtags = hashtags
                state.selected = max(0, state.selected - 1)
            }
        case let .addHashtag(hashtag):
            let hashtags = accountService.add(hashtag: hashtag)

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
