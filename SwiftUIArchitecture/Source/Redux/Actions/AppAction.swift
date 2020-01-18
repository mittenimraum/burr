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
            guard let index = account.hashtags?.firstIndex(of: hashtag) else {
                return
            }
            store.reduce { state in
                state.selected = index
            }
        case let .removeHashtag(hashtag):
            let hashtags = account.remove(hashtag: hashtag)

            store.reduce { state in
                // Workaround for a SwiftUI crash:
                //
                // precondition failure: invalid input index: 2
                //
                // which occurs, when deleting the first hashtag out
                // of the TabView. It seems to be connected to setting
                // a @State var for the 'selection' parameter of the TabView.
                //
                // The code without workaround should just be:
                //
                // state.hashtags = hashtags
                // state.selected = max(0, state.selected - 1)
                //
                let currentState = state.selected
                if currentState == 0 {
                    state.selected = 1
                }
                state.hashtags = hashtags
                if currentState != 0 {
                    state.selected = max(0, state.selected - 1)
                }
            }
        case let .addHashtag(hashtag):
            let hashtags = account.add(hashtag: hashtag)

            store.reduce { state in
                state.hashtags = hashtags
            }
        case let .setHashtags(hashtags):
            account.hashtags = hashtags

            store.reduce { state in
                state.hashtags = hashtags
            }
        }
    }
}
