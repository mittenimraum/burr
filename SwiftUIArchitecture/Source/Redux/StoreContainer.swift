//
//  StoreContainer.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 12.01.20.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Combine
import SwiftUI

struct StoreContainer: EnvironmentKey {
    let store: Store<AppState>

    static var defaultValue: Self { Self.default }

    private static let `default` = Self(store: Store(AppState()))
}

extension EnvironmentValues {
    var container: StoreContainer {
        get {
            self[StoreContainer.self]
        }
        set {
            self[StoreContainer.self] = newValue
        }
    }
}

extension StoreContainer {
    struct Injector: ViewModifier {
        let container: StoreContainer

        init(container: StoreContainer) {
            self.container = container
        }

        func body(content: Content) -> some View {
            content.environment(\.container, container)
        }
    }
}
