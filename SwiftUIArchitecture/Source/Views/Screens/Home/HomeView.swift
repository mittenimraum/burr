//
//  HomeView.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Store
import SwiftUI
import SwiftUIRouter

struct HomeView: View {
    // MARK: - Variables

    var interactor: HomeInteractable
    var body: some View {
        TabView {
            feedPresenter(self.interactor.store, "swiftui")
                .tabItem {
                    Image(systemName: "grid")
                    Text("swiftui")
                }.tag(0)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(interactor: HomeInteractor(store: AppStore(model: AppState())))
    }
}
