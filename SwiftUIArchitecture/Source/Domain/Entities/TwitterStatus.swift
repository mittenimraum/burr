//
//  TwitterStatus.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

struct TwitterStatus: Codable, Identifiable, Hashable {
    // MARK: - Variables

    var id: Int?
    var text: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
