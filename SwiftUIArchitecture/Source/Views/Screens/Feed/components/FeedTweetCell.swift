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

struct FeedTweetCell: View {
    // MARK: - Constants

    let item: TwitterStatus
    let idealWidth: CGFloat

    @State var url: (Bool, URL?) = (false, nil)

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
                    guard let url = URL(string: link) else {
                        return
                    }
                    self.url = (true, url)
                }
        }.sheet(isPresented: $url.0) {
            WebLinkView(url: self.url.1)
        }
    }

    static func attributer(for item: TwitterStatus) -> Attributer {
        Attributer(item.text ?? "")
            .font(Interface.Fonts.medium)
            .color(Interface.Colors.primary)
            .paragraphLineBreakModeWordWrapping
            .paragraphLineSpacing(Interface.Spacing.Fonts.Regular.leading)
            .paragraphApplyStyling
    }
}
