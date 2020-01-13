//
//  FeedView.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import SwiftUI
import SwiftUIRefresh
import SwiftUIRouter

struct FeedView: View {
    // MARK: - Constants

    let id = UUID()

    // MARK: - Variables

    @ObservedObject var interactor: FeedInteractor

    // MARK: - Variables <Private>

    @State private var isPullToRefreshing = false

    // MARK: - Body

    var body: some View {
        GeometryReader { reader in
            NavigationView {
                InfinityList(
                    shouldTriggerBottom: {
                        self.interactor.shouldLoadMore
                    },
                    didReachBottom: {
                        self.interactor.fetch()
                    },
                    content: {
                        ForEach(self.interactor.dataSource, id: \.id) { item in
                            VStack {
                                FeedTweetCell(
                                    item: item,
                                    idealWidth: reader.size.width -
                                        Interface.Spacing.Feed.List.leading -
                                        Interface.Spacing.Feed.List.trailing
                                )
                                Divider()
                            }
                        }
                        .navigationBarItems(trailing:
                            HStack {
                                Button(
                                    action: {
                                        debugPrint("Add new hashtag")
                                    },
                                    label: {
                                        Image(systemName: "plus")
                                    }
                                )
                                .foregroundColor(Color(Interface.Colors.primary))
                        })
                        .navigationBarTitle("#\(self.interactor.term)")
                    }
                )
            }
            .background(PullToRefresh(action: {
                self.interactor.refresh()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isPullToRefreshing = false
                }
            }, isShowing: self.$isPullToRefreshing))
            .id(self.id)
        }
        .onAppear {
            self.interactor.subscribe()
        }
        .onDisappear {
            self.interactor.unsubscribe()
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(interactor: FeedInteractor(store: AppStore(AppState()), term: "#hashtag"))
    }
}
