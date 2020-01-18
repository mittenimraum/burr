//
//  AccountService.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 15.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Combine
import Foundation

// MARK: - AccountService

class AccountService {
    // MARK: - Enums

    enum Preferences: String {
        case hashtags
    }

    // MARK: - Variables

    @UserDefault(key: Preferences.hashtags.rawValue, defaultValue: nil)
    var hashtags: [String]?

    // MARK: - Methods

    func add(hashtag: String) -> [String] {
        var array = hashtags ?? []
        array.append(hashtag)
        hashtags = array
        return array
    }

    func remove(hashtag: String) -> [String] {
        guard let hashtags = hashtags else {
            return []
        }
        guard let index = hashtags.firstIndex(of: hashtag) else {
            return hashtags
        }
        var array = hashtags
        array.remove(at: index)
        self.hashtags = array
        return array
    }
}

// MARK: - Accountable

protocol Accountable {
    var account: AccountService { get }
}

extension Accountable {
    var account: AccountService {
        return Domain.account
    }
}

// MARK: - UserDefault Property Wrapper

@propertyWrapper struct UserDefault<T> {
    // MARK: - Constants

    let key: String
    let defaultValue: T

    // MARK: - Variables <Computed>

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
