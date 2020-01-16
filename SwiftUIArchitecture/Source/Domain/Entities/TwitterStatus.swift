//
//  TwitterStatus.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

struct TwitterStatus: Codable, Identifiable, Hashable {
    // MARK: - Enums

    enum CodingKeys: String, CodingKey {
        case id, text, user
        case createdAt = "created_at"
    }

    // MARK: - Variables

    var id: Int?
    var text: String?
    var user: TwitterUser?
    var createdAt: Date?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension TwitterStatus {
    var formattedDate: String? {
        guard let date = createdAt else {
            return nil
        }
        let fromDate = Date()
        let toDate = Date(timeInterval: fromDate.timeIntervalSince(date), since: fromDate)
        let components = Calendar.current.dateComponents(
            [.hour, .minute, .day, .month, .second], from: fromDate, to: toDate
        )

        if let month = components.month, month > 0 {
            return String(format: "%ldmth", month)
        } else if let day = components.day, day > 0 {
            return String(format: "%ldd", day)
        } else if let hour = components.hour, hour > 0 {
            return String(format: "%ldh", hour)
        } else if let minute = components.minute, minute > 0 {
            return String(format: "%ldm", minute)
        } else if let seconds = components.second, seconds > 0 {
            return String(format: "%lds", seconds)
        }
        return nil
    }
}
