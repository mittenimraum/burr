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

    // MARK: - Variables

    var body: some View {
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
        .padding(EdgeInsets(top: 0, leading: -4, bottom: 0, trailing: 0))
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
