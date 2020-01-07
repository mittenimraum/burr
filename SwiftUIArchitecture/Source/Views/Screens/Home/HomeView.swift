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
            feedPresenter(self.interactor.store)
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("First")
                }.tag(0)
            feedPresenter(self.interactor.store)
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Second")
                }.tag(1)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(interactor: HomeInteractor(store: Store<AppState>(model: AppState())))
    }
}
