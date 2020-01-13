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
    @State private var triggerViewRendering = 0

    // MARK: - Body

    var body: some View {
        GeometryReader { reader in
            NavigationView {
                self.content(reader)
                    .modifier(FeedHeaderView(title: self.interactor.title, action: self.addNewHashtag))
            }
            .background(PullToRefresh(action: {
                self.interactor.refresh()
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

    func content(_ reader: GeometryProxy) -> AnyView {
        DispatchQueue.next {
            self.isPullToRefreshing = false
        }
        switch interactor.status {
        case let .success(items):
            return InfinityList(
                shouldTriggerBottom: {
                    self.interactor.shouldLoadMore
                },
                didReachBottom: {
                    self.interactor.fetch()
                },
                content: {
                    ForEach(items, id: \.self) { item in
                        VStack {
                            FeedTweetCell(
                                item: item,
                                idealWidth: reader.size.width
                                    - Interface.Spacing.Feed.List.leading
                                    - Interface.Spacing.Feed.List.trailing
                            )
                            Divider()
                        }
                    }
                    .modifier(FeedHeaderView(title: self.interactor.title, action: self.addNewHashtag))
                }
            )
            .passthrough { _ in
                // Workaround for the missing frame changes when using
                // .provideFrameChanges() in InfinityList
                //
                // Occurs only the first time the view is rendered
                //
                DispatchQueue.next {
                    self.triggerViewRendering += 1
                }
            }
            .typeErased
        case let .error(error):
            return List {
                VStack {
                    Text(error.localizedDescription)
                        .multilineTextAlignment(.center)
                }
                .frame(width: reader.size.width
                    - Interface.Spacing.Feed.List.leading
                    - Interface.Spacing.Feed.List.trailing)
            }
            .environment(\.defaultMinListRowHeight, reader.size.height
                - reader.frame(in: .global).origin.y
                - reader.safeAreaInsets.bottom)
            .typeErased
        default:
            return VStack {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            }
            .typeErased
        }
    }

    private func addNewHashtag() {}
}

struct FeedHeaderView: ViewModifier {
    var title: String
    var action: () -> Void

    func body(content: Content) -> some View {
        content
            .navigationBarItems(trailing:
                HStack {
                    Button(
                        action: action,
                        label: {
                            Image(systemName: "plus")
                        }
                    )
                    .foregroundColor(Color(Interface.Colors.primary))
            })
            .navigationBarTitle(title)
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(interactor: FeedInteractor(store: AppStore(AppState()), term: "#hashtag"))
    }
}
