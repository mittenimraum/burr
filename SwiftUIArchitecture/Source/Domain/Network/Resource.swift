//
//  Resource.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation
import TinyNetworking

extension Resource {
    var endpointPath: String {
        switch endpoint {
        case let .get(path),
             let .post(path),
             let .put(path),
             let .delete(path):
            return path
        }
    }

    var endpointMethod: String {
        switch endpoint {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        }
    }

    var endpointURL: URL {
        return baseURL.appendingPathComponent(endpointPath)
    }

    var endpointParameters: [String: String] {
        var requestParameters = [String: String]()

        if
            case let .requestWithParameters(parameters, _) = task,
            let value = parameters as? [String: String] {
            requestParameters = value
        }
        return requestParameters
    }
}
