//
//  OnboardingInteractor.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

protocol OnboardingInteractable {
    var store: AppStore { get }
}

struct OnboardingInteractor: OnboardingInteractable {
    let store: AppStore

    init(store: AppStore) {
        self.store = store
    }
}
