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

    // MARK: - Variables <Private>

    @State private var selectedIndex: Int = 0
    @State private var id = UUID()

    // MARK: - Body

    var body: some View {
        Switch {
            Route(path: RoutePath.feed.id) { _ in
                TabView(selection: self.$selectedIndex) {
                    ForEach(self.interactor.hashtags, id: \.self) { hashtag in
                        feedPresenter(self.interactor.store, hashtag)
                            .tabItem {
                                Image(uiImage: "#".image(withAttributes: [.font: UIFont.systemFont(ofSize: Interface.Fonts.Sizes.body, weight: .bold)]))
                                Text(hashtag)
                            }
                            .tag(self.interactor.hashtags.firstIndex(of: hashtag)!)
                    }
                }
                .accentColor(Color(Interface.Colors.secondary))
                .id(self.id)
            }
        }.onAppear {
            self.interactor.subscribe()
        }.onDisappear {
            self.interactor.unsubscribe()
        }
        .onReceive(self.interactor.selected) { value in
            self.selectedIndex = value
            // Refresh the TabView by setting a new id, otherwise
            // the tab content won't be rendered for some reason
            self.id = UUID()
        }
    }
}

extension String {
    var uuid: UUID {
        return UUID()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(interactor: HomeInteractor(store: AppStore(AppState())))
    }
}
