//
//  Combine+Cancellable.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 14.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Combine

extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}

class CancelBag {
    var subscriptions = Set<AnyCancellable>()

    func cancelAll() {
        subscriptions.forEach { $0.cancel() }
    }
}
