//
//  TwitterResponse.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

struct TwitterResponse: Codable {
    // MARK: - Variables

    var statuses: [TwitterStatus]?
}
