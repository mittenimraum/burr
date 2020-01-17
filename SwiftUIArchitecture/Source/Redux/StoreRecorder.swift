//
//  StoreRecorder.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 17.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Combine
import Foundation

class StoreRecorder<State> where State: Codable {
    // MARK: - Variables

    var cancellable: AnyCancellable?

    // MARK: - Variables <Computed>

    var fileName: String {
        return "state.json"
    }

    var directory: URL? {
        return try? FileManager.default
            .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(directoryName)
    }

    var directoryName: String {
        return Bundle.main.bundleIdentifier ?? "cache"
    }

    // MARK: - Methods

    func observe(_ store: Store<State>) {
        cancellable?.cancel()
        cancellable = store.sink(receiveValue: { state in
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.write(state)
            }
        })
    }

    func write(_ state: State) {
        guard
            let json = try? JSONEncoder().encode(state),
            let directory = directory else {
            return
        }
        let file = directory.appendingPathComponent(fileName)

        do {
            if !FileManager.default.fileExists(atPath: directory.path) {
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            }
            try json.write(to: file)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    func read(_ reduce: ((inout State) -> Void)? = nil) -> State? {
        guard let directory = directory else {
            return nil
        }
        let file = directory.appendingPathComponent(fileName)

        do {
            let data = try Data(contentsOf: file)
            var json = try JSONDecoder().decode(State.self, from: data)
            reduce?(&json)

            return json
        } catch {
            debugPrint(error.localizedDescription)
        }
        return nil
    }
}
