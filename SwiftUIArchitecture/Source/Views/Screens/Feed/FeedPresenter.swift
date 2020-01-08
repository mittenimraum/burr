//
//  FeedPresenter.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import SwiftUI

func feedPresenter(_ store: AppStore, _ term: String) -> FeedView {
    let interactor = FeedInteractor(store: store, term: term)

    return FeedView(interactor: interactor)
}
