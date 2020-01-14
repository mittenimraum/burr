//
//  WebLinkView.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 12.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import SwiftUI

struct WebLinkView: View {
    // MARK: - Variables

    var url: URL?

    // MARK: - Variables <Environment>

    @Environment(\.presentationMode) var presentationMode

    // MARK: - Variables <Oberved>

    @ObservedObject var webViewStore = WebViewStore()

    // MARK: - Variables <Private>

    @State private var showShareSheet = false

    // MARK: - Body

    var body: some View {
        NavigationView {
            WebView(webView: webViewStore.webView)
                .navigationBarTitle(Text(verbatim: webViewStore.webView.title ?? ""), displayMode: .inline)
                .navigationBarItems(leading: HStack {
                    Button(action: share) {
                        Image(systemName: "link")
                            .imageScale(.large)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .foregroundColor(Color(Interface.Colors.primary))
                    }
                    Button(action: goBack) {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .foregroundColor(webViewStore.webView.canGoBack ? Color(Interface.Colors.primary) : .gray)
                    }.disabled(!webViewStore.webView.canGoBack)
                    Button(action: goForward) {
                        Image(systemName: "chevron.right")
                            .imageScale(.large)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .foregroundColor(webViewStore.webView.canGoForward ? Color(Interface.Colors.primary) : .gray)
                    }.disabled(!webViewStore.webView.canGoForward)

                }, trailing: HStack {
                    Button(action: close) {
                        Image(systemName: "xmark")
                            .imageScale(.large)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .foregroundColor(Color(Interface.Colors.primary))
                    }

                })
        }.onAppear {
            guard let url = self.url else {
                return
            }
            self.webViewStore.webView.load(URLRequest(url: url))
        }.onDisappear {
            self.webViewStore.dispose()
        }.sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [self.url as Any], applicationActivities: [SafariActivity()])
        }
    }

    func share() {
        showShareSheet = true
    }

    func close() {
        presentationMode.wrappedValue.dismiss()
    }

    func goBack() {
        webViewStore.webView.goBack()
    }

    func goForward() {
        webViewStore.webView.goForward()
    }
}
