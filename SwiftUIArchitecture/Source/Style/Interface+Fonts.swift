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
        }

        static let regular = UIFont(name: "HelveticaNeue", size: Sizes.body)
        static let medium = UIFont(name: "HelveticaNeue-Medium", size: Sizes.body)
        static let semibold = UIFont(name: "HelveticaNeue-Bold", size: Sizes.title)
        static let bold = UIFont(name: "HelveticaNeue-CondensedBlack", size: Sizes.title)
    }
}
