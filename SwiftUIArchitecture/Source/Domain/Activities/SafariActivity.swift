//
//  SafariActivity.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 12.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation
import UIKit

class SafariActivity: UIActivity {
    // MARK: - Variables

    var url: URL?

    // MARK: - Methods

    override var activityType: UIActivity.ActivityType? {
        return UIActivity.ActivityType(rawValue: "SafariActivity")
    }

    override var activityTitle: String? {
        return L10n.activitySafariOpen
    }

    override var activityImage: UIImage? {
        return UIImage(systemName: "safari")
    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return activityItems
            .compactMap { $0 as? URL }
            .filter { UIApplication.shared.canOpenURL($0) }
            .isEmpty == false
    }

    override func prepare(withActivityItems activityItems: [Any]) {
        url = activityItems
            .compactMap { $0 as? URL }
            .filter { UIApplication.shared.canOpenURL($0) }
            .first
    }

    override func perform() {
        guard let url = url else {
            activityDidFinish(false)
            return
        }
        UIApplication.shared.open(url)

        activityDidFinish(true)
    }
}
