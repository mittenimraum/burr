//
//  TweetCell.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 09.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import AttributedTextView
import Foundation
import SwiftUI

struct FeedCell: View {
    // MARK: - Constants

    let item: FeedItem
    let idealWidth: CGFloat

    // MARK: - Variables <Private>

    @State private var formattedDate = String()

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AttributedText(idealWidth: idealWidth) {
                Self.attributer(for: self.item)
                    .matchHashtags
                    .makeInteract { hashtag in
                        guard let link = TwitterAPI.urlString(hashtag: hashtag) else {
                            return
                        }
                        self.item.open.run(link)
                    }
                    .matchMentions
                    .makeInteract { mention in
                        guard let link = TwitterAPI.urlString(mention: mention) else {
                            return
                        }
                        self.item.open.run(link)
                    }
                    .matchHyperlinks
                    .makeInteract { link in
                        self.item.open.run(link)
                    }
            }
            HStack(alignment: .center) {
                Text(self.item.status.user?.formattedUsername ?? "")
                    .underline()
                    .onTapGesture {
                        guard
                            let mention = self.item.status.user?.formattedUsername,
                            let link = TwitterAPI.urlString(mention: mention) else {
                            return
                        }
                        self.item.open.run(link)
                    }
                    .foregroundColor(Color(Interface.Colors.tertiary))
                    .font(Font(Interface.Fonts.medium.withSize(Interface.Fonts.Sizes.source)))
                Text(self.formattedDate)
                    .foregroundColor(Color(Interface.Colors.tertiary))
                    .font(Font(Interface.Fonts.medium.withSize(Interface.Fonts.Sizes.source)))
                    .onReceive(self.item.timer.publisher) { _ in
                        self.updateTime()
                    }.onAppear {
                        self.updateTime()
                    }
            }.offset(x: 4, y: 0)
            Spacer(minLength: 10)
        }
        .padding(EdgeInsets(top: 0, leading: -4, bottom: 0, trailing: 0))
    }

    private func updateTime() {
        guard let newValue = item.status.formattedDate, newValue != formattedDate else {
            return
        }
        formattedDate = newValue
    }

    static func attributer(for item: FeedItem) -> Attributer {
        Attributer(item.status.text ?? "")
            .font(Interface.Fonts.medium)
            .color(Interface.Colors.primary)
            .paragraphLineBreakModeWordWrapping
            .paragraphLineSpacing(Interface.Spacing.Fonts.Regular.leading)
            .paragraphApplyStyling
    }
}
