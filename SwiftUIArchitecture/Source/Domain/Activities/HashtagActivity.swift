//
//  HashtagActivity.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 16.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation
import UIKit

class HashtagActivity: UIActivity {
    // MARK: - Variables

    var item: HashtagActivityItem?

    // MARK: - Methods

    override var activityType: UIActivity.ActivityType? {
        return UIActivity.ActivityType(rawValue: "HashtagActivity")
    }

    override var activityTitle: String? {
        return L10n.activityHashtagAdd(item?.hashtag ?? "")
    }

    override var activityImage: UIImage? {
        return "#".image(withAttributes: [
            .font: UIFont.systemFont(ofSize: Interface.Fonts.Sizes.body, weight: .bold),
            .foregroundColor: Interface.Colors.primary,
        ])
    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        item = activityItems
            .compactMap { $0 as? HashtagActivityItem }
            .filter { $0.isValid && $0.isUnique }
            .first
        return item != nil
    }

    override func perform() {
        guard
            let item = item,
            let store = item.store,
            let hashtag = item.strippedHashtag else {
            activityDidFinish(false)
            return
        }
        activityDidFinish(true)

        item.action?()

        DispatchQueue.next {
            store.dispatch(AppAction.addHashtag(hashtag))
            store.dispatch(AppAction.selectHashtag(hashtag))
        }
    }
}

struct HashtagActivityItem {
    var hashtag: String?
    var action: (() -> Void)?

    var isValid: Bool {
        return hashtag?.isHashtag == true
    }

    var isUnique: Bool {
        guard
            let hashtag = strippedHashtag,
            let hashtags = Domain.accountService.hashtags else {
            return false
        }
        return hashtags.contains(hashtag) == false
    }

    var store: AppStore? {
        guard let delegate = UIApplication.shared
            .windows
            .compactMap({ $0.windowScene?.delegate as? SceneDelegate })
            .first else {
            return nil
        }
        return delegate.coordinator.store
    }

    var strippedHashtag: String? {
        return hashtag?.replacingOccurrences(of: "#", with: "")
    }
}
