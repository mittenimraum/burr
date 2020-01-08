//
//  AttributedTextBuilder.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 09.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import AttributedTextView

@_functionBuilder
public struct AttributedTextBuilder {
    public static func buildBlock(_ components: Attributer...) -> Attributer {
        var attributer = Attributer(String())
        for component in components {
            attributer = attributer.append(component)
        }
        return attributer
    }
}
