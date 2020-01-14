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
                    debugPrint(hashtag)
                }
                .matchMentions
                .makeInteract { mention in
                    debugPrint(mention)
                }
                .matchHyperlinks
                .makeInteract { link in
                    self.item.open.run(link)
                }
        }
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
