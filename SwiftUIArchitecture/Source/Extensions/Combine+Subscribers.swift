//
//  Combine+Subscribers.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 14.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Combine

extension Subscribers.Completion {
    var error: Failure? {
        switch self {
        case let .failure(error): return error
        default: return nil
        }
    }
}
