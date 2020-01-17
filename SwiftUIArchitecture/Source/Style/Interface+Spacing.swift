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
                static let leading: CGFloat = 6
            }

            struct Medium {
                static let leading: CGFloat = 3
            }
        }

        struct General {
            struct NavigationBar {
                static let largeTitleLeading: CGFloat = 16
            }

            struct List {
                static let leading: CGFloat = 20
                static let trailing: CGFloat = 4
                static let insets = EdgeInsets(
                    top: 10,
                    leading: 0,
                    bottom: 0,
                    trailing: 16
                )
            }
        }

        struct Feed {
            static let listInsets = EdgeInsets(
                top: General.List.insets.top,
                leading: General.List.insets.leading + General.NavigationBar.largeTitleLeading,
                bottom: General.List.insets.bottom,
                trailing: General.List.insets.trailing
            )
            static let padding = EdgeInsets(
                top: 0,
                leading: -General.NavigationBar.largeTitleLeading + General.List.leading,
                bottom: 0,
                trailing: General.List.trailing
            )
            static let unknownPadding: CGFloat = 30
        }

        struct Onboarding {
            static let spacing: CGFloat = 30
            static let padding = EdgeInsets(
                top: General.List.insets.top + 50,
                leading: General.List.leading,
                bottom: 0,
                trailing: General.List.leading
            )
        }
    }
}
