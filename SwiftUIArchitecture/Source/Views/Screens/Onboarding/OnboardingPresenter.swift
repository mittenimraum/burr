//
//  OnboardingPresenter.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import SwiftUI

func onboardingPresenter(_ store: AppStore) -> OnboardingView {
    let interactor = OnboardingInteractor(store: store)

    return OnboardingView(interactor: interactor)
}
