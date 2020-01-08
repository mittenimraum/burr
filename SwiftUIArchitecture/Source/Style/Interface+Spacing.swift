//
//  Interface+Spacing.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 09.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation
import UIKit

extension Interface {
    struct Spacing {
        // MARK: - Fonts

        struct Fonts {
            struct Regular {
                static let leading: CGFloat = 12
            }
        }

        struct Feed {
            struct List {
                static let leading: CGFloat = 20
                static let trailing: CGFloat = 20
            }
        }
    }
}
