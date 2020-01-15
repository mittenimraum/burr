//
//  Interface+Spacing.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 09.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import SwiftUI
import UIKit

extension Interface {
    struct Spacing {
        // MARK: - Fonts

        struct Fonts {
            struct Regular {
                static let leading: CGFloat = 8
            }
        }

        struct General {
            struct List {
                static let leading: CGFloat = 24
                static let trailing: CGFloat = 24
            }
        }

        struct Onboarding {
            static let spacing: CGFloat = 40
            static let padding = EdgeInsets(
                top: 80,
                leading: General.List.leading,
                bottom: 0,
                trailing: General.List.trailing
            )
        }
    }
}
