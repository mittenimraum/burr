//
//  FeedItem.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 14.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

struct FeedItem {
    let status: TwitterStatus
    let open: Action<String>
}
