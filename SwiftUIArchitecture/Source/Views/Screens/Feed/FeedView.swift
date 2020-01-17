//
//  FeedView.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Introspect
import SwiftUI
import SwiftUIRefresh
import SwiftUIRouter

struct FeedView: View {
    // MARK: - Enums

    enum Actionsheet: Int, Identifiable {
        case removeHashtag

        var id: Int {
            rawValue
        }
    }

    enum Sheet: Identifiable {
        case addHashtag
        case webPreview(URL)

        var id: Int {
            switch self {
            case .addHashtag: return 0
            case .webPreview: return 1
            }
        }
    }

    // MARK: - Variables

    @ObservedObject var interactor: FeedInteractor

    // MARK: - Variables <Private>

    @State private var isPullToRefreshing = false
    @State private var triggerViewRendering = 0
    @State private var modal: Sheet?
    @State private var actionsheet: Actionsheet?

    // MARK: - Body

    var body: some View {
        GeometryReader { reader in
            NavigationView {
                self.content(reader)
                    .modifier(FeedHeaderView(
                        title: self.interactor.title,
                        add: self.addHashtag,
                        remove: self.removeHashtag,
                        shouldShowRemove: self.interactor.shouldShowRemove
                    ))
            }
            .pullToRefresh(
                isShowing: self.$isPullToRefreshing,
                onRefresh: {
                    self.interactor.refresh()
                }
            )
            .padding(Interface.Spacing.Feed.padding)
            .id(self.interactor.hashtag)
            .sheet(
                item: self.$modal,
                onDismiss: {
                    self.modal = nil
                },
                content: { value in
                    self.view(for: value)
                }
            )
            .actionSheet(item: self.$actionsheet) { value in
                self.view(for: value)
            }
        }
        .onAppear {
            self.interactor.subscribe()
            self.interactor.refresh()
            self.interactor.select()
        }
        .onDisappear {
            self.interactor.unsubscribe()
        }
        .onReceive(self.interactor.url) { value in
            guard let url = value else {
                return
            }
            self.modal = .webPreview(url)
        }
    }

    func content(_ reader: GeometryProxy) -> AnyView {
        DispatchQueue.next {
            self.isPullToRefreshing = false
        }
        switch interactor.status {
        case let .success(items):
            return InfinityList(
                insets: Interface.Spacing.Feed.listInsets,
                shouldTriggerBottom: {
                    self.interactor.shouldLoadMore
                },
                didReachBottom: {
                    self.interactor.fetch()
                },
                content: {
                    ForEach(items, id: \.status) { item in
                        VStack {
                            FeedCell(
                                item: item,
                                idealWidth: reader.size.width
                                    - Interface.Spacing.Feed.padding.leading
                                    - Interface.Spacing.Feed.padding.trailing
                                    - Interface.Spacing.Feed.listInsets.leading
                                    - Interface.Spacing.Feed.listInsets.trailing
                            )
                            Divider()
                        }
                    }
                    .modifier(FeedHeaderView(
                        title: self.interactor.title,
                        add: self.addHashtag,
                        remove: self.removeHashtag,
                        shouldShowRemove: self.interactor.shouldShowRemove
                    ))
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
            return view(for: error.localizedDescription, reader: reader)
        default:
            return VStack {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
                    .offset(x: 0, y: -20)
            }
            .typeErased
        }
    }

    private func view(for message: String, reader: GeometryProxy) -> AnyView {
        return List {
            VStack {
                Text(message)
                    .font(Font(Interface.Fonts.regular.withSize(Interface.Fonts.Sizes.error)))
                    .multilineTextAlignment(.center)
            }
            .frame(width: reader.size.width
                - Interface.Spacing.Feed.padding.leading
                - Interface.Spacing.Feed.padding.trailing
                - Interface.Spacing.Feed.listInsets.leading
                - Interface.Spacing.Feed.listInsets.trailing)
        }
        .environment(\.defaultMinListRowHeight, reader.size.height
            - reader.frame(in: .global).origin.y
            - reader.safeAreaInsets.bottom
            - 44)
        .typeErased
    }

    private func view(for sheet: Sheet) -> AnyView {
        switch sheet {
        case .addHashtag:
            return AnyView(onboardingPresenter(interactor.store))
        case let .webPreview(url):
            return AnyView(WebLinkView(url: url))
        }
    }

    private func view(for actionsheet: Actionsheet) -> ActionSheet {
        switch actionsheet {
        case .removeHashtag:
            return ActionSheet(
                title: Text(interactor.l10nRemoveText),
                buttons: [
                    .destructive(Text(self.interactor.l10nYes), action: interactor.remove),
                    .default(Text(self.interactor.l10nNo)),
                ]
            )
        }
    }

    private func removeHashtag() {
        actionsheet = .removeHashtag
    }

    private func addHashtag() {
        modal = .addHashtag
    }
}

struct FeedHeaderView: ViewModifier {
    var title: String
    var add: () -> Void
    var remove: () -> Void
    var shouldShowRemove: Bool

    func body(content: Content) -> some View {
        content
            .navigationBarItems(
                trailing:
                HStack {
                    if shouldShowRemove {
                        Button(action: { self.remove() }, label: { Image(systemName: "minus") })
                            .frame(width: 30, alignment: .center)
                            .foregroundColor(Color(Interface.Colors.primary))
                            .opacity(0.15)
                    }
                    Button(action: { self.add() }, label: { Image(systemName: "plus") })
                        .frame(width: 30, alignment: .center)
                        .foregroundColor(Color(Interface.Colors.primary))
                }
            )
            .navigationBarTitle(title)
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(interactor: FeedInteractor(store: AppStore(AppState()), hashtag: "hashtag"))
    }
}
