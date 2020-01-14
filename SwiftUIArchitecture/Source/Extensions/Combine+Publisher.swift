//
//  Combine+Publisher.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 14.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Combine
import Foundation

extension Publisher {
    func sinkToResult(_ result: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                result(.failure(error))
            default: break
            }
        }, receiveValue: { value in
            result(.success(value))
        })
    }

    func extractUnderlyingError() -> Publishers.MapError<Self, Failure> {
        mapError {
            (($0 as NSError).userInfo[NSUnderlyingErrorKey] as? Failure) ?? $0
        }
    }
}
