//
//  Foundation+String.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation

extension String {
    var fileName: String? {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    var fileExtension: String? {
        return URL(fileURLWithPath: self).pathExtension
    }
}
