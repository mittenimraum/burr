//
//  AppTypes.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 14.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Combine
import Foundation
import SwiftUIRouter

// MARK: - Types

typealias AppStore = Store<AppState>
typealias AppRouter = Router<RouterView<RootView>>
typealias AppRecorder = StoreRecorder<AppState>
typealias Observable<T> = CurrentValueSubject<T, Never>

// MARK: - Action

struct Action<Input> {
    // MARK: - Types

    typealias ActionType = (Input) -> Void

    // MARK: - Constants <Private>

    private let execute: ActionType

    // MARK: - Init

    init(execute: @escaping ActionType) {
        self.execute = execute
    }

    // MARK: - Methods

    func run(_ input: Input) {
        execute(input)
    }
}

// MARK: - Disposable

protocol Disposable {
    mutating func dispose()
}
