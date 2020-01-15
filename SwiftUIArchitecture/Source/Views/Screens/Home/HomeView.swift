//
//  HomeView.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import SwiftUI
import SwiftUIRouter

struct HomeView: View {
    // MARK: - Variables

    @ObservedObject var interactor: HomeInteractor

    // MARK: - Body

    var body: some View {
        Switch {
            Route(path: RoutePath.feed.id) { _ in
                TabView {
                    ForEach(self.interactor.hashtags.indices, id: \.self) { index in
                        feedPresenter(self.interactor.store, self.interactor.hashtags[index])
                            .tabItem {
                                Image(uiImage: "#".image(withAttributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
                                Text(self.interactor.hashtags[index])
                            }
                            .tag(index)
                    }
                }
                .accentColor(Color(Interface.Colors.secondary))
            }
        }.onAppear {
            self.interactor.subscribe()
        }.onDisappear {
            self.interactor.unsubscribe()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(interactor: HomeInteractor(store: AppStore(AppState())))
    }
}
