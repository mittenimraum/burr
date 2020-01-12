//
//  AppState.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 07.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import SwiftUIRouter

struct AppState: Equatable, Codable {
    var route: RouteState = RouteState()
    var feed: FeedState = FeedState()
}
