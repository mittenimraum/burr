//
//  AppAction.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 07.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

enum AppAction: Reducable, Accountable {
    case setHashtags([String])

    func reduce(store: AppStore) {
        switch self {
        case let .setHashtags(hashtags):
            accountService.hashtags = hashtags

            store.reduce { state in
                state.hashtags = hashtags
            }
        }
    }
}
