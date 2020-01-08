//
//  Domain.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation
import TinyNetworking

struct Domain {
    static var twitterAPI = TinyNetworking<TwitterAPI>()
}
