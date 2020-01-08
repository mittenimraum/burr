//
//  Networkable.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation
import TinyNetworking

protocol Networkable {
    var twitterAPI: TinyNetworking<TwitterAPI> { get }
}

extension Networkable {
    var twitterAPI: TinyNetworking<TwitterAPI> {
        return Domain.twitterAPI
    }
}
