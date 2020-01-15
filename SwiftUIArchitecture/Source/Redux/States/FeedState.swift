//
//  FeedState.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

struct FeedState: Codable, Equatable {
    // MARK: - Variables

    var items: [String: ListStatus<[TwitterStatus]>] = [:]
}
