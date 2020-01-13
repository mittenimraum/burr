//
//  WebView.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 12.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Combine
import Foundation
import SwiftUI
import WebKit

/// A container for using a WKWebView in SwiftUI
public struct WebView: View, UIViewRepresentable {
    /// The WKWebView to display
    public let webView: WKWebView

    public typealias UIViewType = UIViewContainerView<WKWebView>

    public init(webView: WKWebView) {
        self.webView = webView
    }

    public func makeUIView(context _: UIViewRepresentableContext<WebView>) -> WebView.UIViewType {
        return UIViewContainerView()
    }

    public func updateUIView(_ uiView: WebView.UIViewType, context _: UIViewRepresentableContext<WebView>) {
        // If its the same content view we don't need to update.
        if uiView.contentView !== webView {
            uiView.contentView = webView
        }
    }
}

/// A UIView which simply adds some view to its view hierarchy
public class UIViewContainerView<ContentView: UIView>: UIView {
    var contentView: ContentView? {
        willSet {
            contentView?.removeFromSuperview()
        }
        didSet {
            if let contentView = contentView {
                addSubview(contentView)
                contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    contentView.topAnchor.constraint(equalTo: topAnchor),
                    contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
                ])
            }
        }
    }
}

public class WebViewStore: ObservableObject, Disposable {
    // MARK: - Variables

    @Published public var webView: WKWebView {
        didSet {
            setupObservers()
        }
    }

    // MARK: - Variables <Private>

    private var observers: [NSKeyValueObservation] = []

    // MARK: - Init

    public init(webView: WKWebView = WKWebView()) {
        self.webView = webView

        setupObservers()
    }

    // MARK: - Oberservers

    private func setupObservers() {
        func subscriber<Value>(for keyPath: KeyPath<WKWebView, Value>) -> NSKeyValueObservation {
            return webView.observe(keyPath, options: [.prior]) { _, change in
                if change.isPrior {
                    self.objectWillChange.send()
                }
            }
        }
        // Setup observers for all KVO compliant properties
        observers = [
            subscriber(for: \.title),
            subscriber(for: \.url),
            subscriber(for: \.isLoading),
            subscriber(for: \.estimatedProgress),
            subscriber(for: \.hasOnlySecureContent),
            subscriber(for: \.serverTrust),
            subscriber(for: \.canGoBack),
            subscriber(for: \.canGoForward),
        ]
    }

    func dispose() {
        observers.forEach { $0.invalidate() }
        webView.removeFromSuperview()
        webView.dispose()
    }

    deinit {
        dispose()
    }
}

extension WKWebView: Disposable {
    func dispose() {
        guard let url = URL(string: "about:blank") else {
            return
        }
        load(URLRequest(url: url))
    }
}
