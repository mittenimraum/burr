//
//  Foundation+DispatchQueue.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    // MARK: - Structs

    struct Delay {
        // MARK: - Types

        typealias Closure = (_ value: Bool) -> Void

        // MARK: - Variables <Private>

        private var cancelClosure: Closure?

        // MARK: Init

        init(_ cancelClosure: @escaping Closure) {
            self.cancelClosure = cancelClosure
        }

        // MARK: - Actions

        func cancel() {
            cancelClosure?(true)
        }

        func finish() {
            cancelClosure?(false)
        }
    }

    // MARK: - Variables <Private>

    private static var _onceTracker = [String]()

    // MARK: - Methods

    class func once(file: String = #file, function: String = #function, line: Int = #line, block: @escaping () -> Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token, block)
    }

    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.

     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    @discardableResult
    class func once(_ token: String, _ block: (() -> Void)? = nil) -> String {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _onceTracker.contains(token) {
            return token
        }
        _onceTracker.append(token)

        block?()

        return token
    }

    class func clear(_ token: String) {
        while let index = _onceTracker.firstIndex(where: { $0.contains(token) }) {
            _onceTracker.remove(at: index)
        }
    }

    class func clear() {
        _onceTracker.removeAll()
    }

    @discardableResult
    class func delay(_ time: Double, _ closure: @escaping () -> Void) -> Delay? {
        var result: Delay?
        let resultClosure: Delay.Closure = { cancel in
            result = nil

            guard cancel == false else {
                return
            }
            DispatchQueue.main.async {
                closure()
            }
        }
        result = Delay(resultClosure)

        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            result?.finish()
        }
        return result
    }

    /// Wait for the next run in the main RunLoop.
    ///
    /// - Parameters:
    ///   - closure: The closure to be executed after the next run started.

    class func next(_ closure: @escaping () -> Void) {
        delay(0, closure)
    }
}

public func += (lhs: inout [DispatchQueue.Delay?], rhs: DispatchQueue.Delay?) {
    return lhs.append(rhs)
}
