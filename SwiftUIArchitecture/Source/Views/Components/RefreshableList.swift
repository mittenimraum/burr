//
//  PullToRefresh.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 10.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Combine
import SwiftUI

// MARK: - PullToRefresh

struct PullToRefresh {
    // MARK: - Enums

    enum Status: Equatable {
        case stopped
        case progress(CGFloat)
        case running

        static func == (lhs: Status, rhs: Status) -> Bool {
            switch (lhs, rhs) {
            case (.stopped, .stopped): return true
            case (.running, .running): return true
            case let (.progress(lhsValue), .progress(rhsValue)):
                return lhsValue == rhsValue
            default:
                return false
            }
        }
    }

    // MARK: - Variables

    static var pullRange: CGFloat = 120
    static var viewOffset: CGPoint = CGPoint(x: 0, y: -90)
    static var viewHeight: CGFloat = 40
}

// MARK: - RefreshableList

struct RefreshableList<Content: View>: View {
    // MARK: - Constants

    let shouldTriggerBottom: () -> Bool
    let didRefresh: (() -> Void)?
    let didReachBottom: (() -> Void)?
    let content: () -> Content

    // MARK: - Variables

    @State var status: PullToRefresh.Status = .stopped

    // MARK: - Init

    init(
        shouldTriggerBottom: @escaping () -> Bool,
        didRefresh: (() -> Void)?,
        didReachBottom: (() -> Void)?,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.shouldTriggerBottom = shouldTriggerBottom
        self.didRefresh = didRefresh
        self.didReachBottom = didReachBottom
        self.content = content
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { reader in
            List {
                PullToRefreshView(status: self.$status)
                self.content().provideFrameChanges()
            }
            .environment(\.defaultMinListRowHeight, PullToRefresh.viewHeight)
            .offset(x: 0, y: -PullToRefresh.viewHeight)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: -PullToRefresh.viewHeight, trailing: 0))
            .handleViewTreeFrameChanges { change in
                self.processStatus(change, with: reader)
                self.processInfinity(change, with: reader)
            }
        }
    }

    // MARK: - Methods

    private func processStatus(_ change: ViewTreeFrameChanges, with _: GeometryProxy) {
        guard let bounds = change.first?.value, bounds.size.height > 0 else {
            return
        }
        let previousStatus = status
        let progress = CGFloat(max(0, min(1, (bounds.origin.y - 6.5) / PullToRefresh.pullRange)))

        if progress == 0 {
            status = .stopped
        } else if progress < 1 {
            status = .progress(progress)
        } else {
            status = .running
        }

        guard previousStatus != status else {
            return
        }
        switch status {
        case .running:
            didRefresh?()
        default:
            break
        }
    }

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

// MARK: - PullToRefreshView

struct PullToRefreshView: View {
    // MARK: - Variables

    @Binding var status: PullToRefresh.Status

    // MARK: - Body

    var body: some View {
        GeometryReader { _ in
            RefreshView(status: self.$status)
                .opacity(self.opacity())
                .offset(x: PullToRefresh.viewOffset.x, y: PullToRefresh.viewOffset.y)
        }
    }

    // MARK: - Methods

    private func opacity() -> Double {
        switch status {
        case let .progress(value):
            return Double(value)
        case .running:
            return 1
        default:
            return 0
        }
    }
}

// MARK: - Spinner

struct Spinner: View {
    // MARK: - Variables

    @Binding var percentage: CGFloat

    // MARK: - Body

    var body: some View {
        GeometryReader { _ in
            ForEach(1 ... Int(max(1, 12 * self.percentage)), id: \.self) { index in
                Rectangle()
                    .fill(Color.gray)
                    .cornerRadius(1)
                    .frame(width: 3, height: 9)
                    .opacity(Double(index) / 12.0)
                    .offset(x: 0, y: -8)
                    .rotationEffect(.degrees(Double(30 * index)), anchor: .bottom)
            }.offset(x: 20, y: 10)
        }.frame(width: PullToRefresh.viewHeight, height: PullToRefresh.viewHeight)
    }
}

struct Spinner_Previews: PreviewProvider {
    static var previews: some View {
        Spinner(percentage: .constant(1))
    }
}

// MARK: - RefreshView

struct RefreshView: View {
    // MARK: - Variables

    @Binding var status: PullToRefresh.Status

    // MARK: - Variables <Private>

    private var indicator: AnyView? {
        switch status {
        case .running:
            return ActivityIndicator(isAnimating: .constant(true), style: .large)
                .rotationEffect(.degrees(90))
                .typeErased
        case let .progress(value):
            return Spinner(percentage: .constant(value)).typeErased
        default:
            return nil
        }
    }

    // MARK: - Body

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                self.indicator
            }
            Spacer()
        }
    }
}
