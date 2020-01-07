//
//  HomePresenter.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import SwiftUI

func homePresenter(_ store: AppStore) -> HomeView {
    let interactor = HomeInteractor(store: store)

    return HomeView(interactor: interactor)
}
