//
//  Interface+Fonts.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 09.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation
import UIKit

extension Interface {
    struct Fonts {
        struct Sizes {
            static let body: CGFloat = 24
            static let title: CGFloat = 28
            static let source: CGFloat = 18
            static let hint: CGFloat = 16
        }

        static let regular = UIFont(name: "HelveticaNeue", size: Sizes.body)
            ?? UIFont.systemFont(ofSize: Sizes.body, weight: .regular)
        static let medium = UIFont(name: "HelveticaNeue-Medium", size: Sizes.body)
            ?? UIFont.systemFont(ofSize: Sizes.body, weight: .medium)
        static let semibold = UIFont(name: "HelveticaNeue-Bold", size: Sizes.title)
            ?? UIFont.systemFont(ofSize: Sizes.title, weight: .semibold)
        static let bold = UIFont(name: "HelveticaNeue-CondensedBlack", size: Sizes.title)
            ?? UIFont.systemFont(ofSize: Sizes.title, weight: .bold)
    }
}
