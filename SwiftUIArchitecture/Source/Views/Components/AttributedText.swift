//
//  AttributedText.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 09.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import AttributedTextView
import Combine
import SwiftUI
import UIKit

public final class AttributedText: UIViewRepresentable {
    typealias ContentSize = (width: CGFloat, height: CGFloat)

    var idealWidth: CGFloat
    var attributer: Attributer

    private init(_ idealWidth: CGFloat, _ attributer: Attributer) {
        self.idealWidth = idealWidth
        self.attributer = attributer
    }

    public convenience init(idealWidth: CGFloat, @AttributedTextBuilder _ builder: () -> Attributer) {
        self.init(idealWidth, builder())
    }

    public func makeUIView(context _: UIViewRepresentableContext<AttributedText>) -> AttributedTextView {
        let textView = AutosizableAttributedTextView(frame: CGRect(x: 0, y: 0, width: idealWidth, height: 1))
        textView.backgroundColor = .clear
        textView.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: Interface.Colors.secondary,
            NSAttributedString.Key.underlineColor: Interface.Colors.secondary,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
        textView.forceIntrinsicContentSizeToBeContentSize = true
        textView.attributer = attributer

        return textView
    }

    public func updateUIView(_ textView: AttributedTextView, context _: UIViewRepresentableContext<AttributedText>) {
        textView.attributer = attributer
    }
}

struct AttributedText_Preview: PreviewProvider {
    static var previews: some View {
        AttributedText(idealWidth: 100) {
            Attributer("Text")
        }
    }
}

private class AutosizableAttributedTextView: AttributedTextView {
    override var attributer: Attributer {
        didSet {
            sizeToFit()
        }
    }
}
