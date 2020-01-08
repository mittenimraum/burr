//
//  FeedView.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Store
import SwiftUI
import SwiftUIRouter

struct FeedView: View {
    @ObservedObject var interactor: FeedInteractor

    var body: some View {
        GeometryReader { reader in
            NavigationView {
                RefreshableList(
                    shouldTriggerBottom: {
                        self.interactor.shouldLoadMore
                    },
                    didRefresh: {
                        self.interactor.refresh()
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
        }
        .onAppear {
            self.interactor.subscribe()
            self.interactor.fetch()
        }
        .onDisappear {
            self.interactor.unsubscribe()
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(interactor: FeedInteractor(store: AppStore(model: AppState()), term: "#hashtag"))
    }
}
