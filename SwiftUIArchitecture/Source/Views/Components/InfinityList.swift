//
//  InfinityList.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 10.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Combine
import SwiftUI

// MARK: - InfinityList

struct InfinityList<Content: View>: View {
    // MARK: - Constants

    let insets: EdgeInsets
    let shouldTriggerBottom: () -> Bool
    let didReachBottom: (() -> Void)?
    let content: () -> Content

    // MARK: - Init

    init(
        insets: EdgeInsets = EdgeInsets(),
        shouldTriggerBottom: @escaping () -> Bool,
        didReachBottom: (() -> Void)?,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.insets = insets
        self.shouldTriggerBottom = shouldTriggerBottom
        self.didReachBottom = didReachBottom
        self.content = content
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { reader in
            List {
                self.content()
                    .listRowInsets(self.insets)
                    .provideFrameChanges()
            }
            .handleViewTreeFrameChanges { change in
                self.processInfinity(change, with: reader)
            }
        }
    }

    // MARK: - Methods

    private func processInfinity(_ change: ViewTreeFrameChanges, with reader: GeometryProxy) {
        guard let tuple = change.first, tuple.value.height > reader.size.height else {
            return
        }
        let distance = max(0, tuple.value.origin.y + (tuple.value.height - reader.size.height))

        guard distance < reader.size.height, shouldTriggerBottom() else {
            return
        }
        didReachBottom?()
    }
}
