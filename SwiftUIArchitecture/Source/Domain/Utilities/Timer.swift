//
//  Timer.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 16.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Combine
import Foundation

class Timer {
    private let intervalSubject: CurrentValueSubject<TimeInterval, Never>

    var interval: TimeInterval {
        get {
            intervalSubject.value
        }
        set {
            intervalSubject.send(newValue)
        }
    }

    var publisher: AnyPublisher<Date, Never> {
        intervalSubject
            .map {
                Foundation.Timer.TimerPublisher(interval: $0, runLoop: .main, mode: .common).autoconnect()
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }

    init(interval: TimeInterval = 60.0) {
        intervalSubject = CurrentValueSubject<TimeInterval, Never>(interval)
    }
}
