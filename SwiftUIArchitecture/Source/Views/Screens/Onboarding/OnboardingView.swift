//
//  OnboardingView.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 07.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Store
import SwiftUI
import SwiftUIRouter

struct OnboardingView: View {
    // MARK: - Variables

    var interactor: OnboardingInteractable
    var body: some View {
        Link(to: RoutePath.feed.id) {
            Text("Onboarding")
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(interactor: OnboardingInteractor(store: AppStore(model: AppState())))
    }
}
