//
//  AppState.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 07.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Store
import SwiftUIRouter

struct AppState: SerializableModelProtocol {
    var route: RouteState = RouteState()
    var feed: FeedState = FeedState()
}
