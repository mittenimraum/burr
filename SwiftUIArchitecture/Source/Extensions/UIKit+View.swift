//
//  UIKit+View.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 15.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var isOnScreen: Bool {
        return isInScreenRect()
    }

    var isVisible: Bool {
        guard isOnScreen, isHidden == false, alpha > 0, window != nil else {
            return false
        }
        return true
    }

    func isInScreenRect(_ rect: CGRect = UIScreen.main.bounds) -> Bool {
        guard
            let rootView = UIApplication.shared.windows.first?.rootViewController?.view,
            let superView = superview else {
            return false
        }
        let viewFrame = superView.convert(frame, to: rootView)
        let intersection = viewFrame.intersection(rect)

        return intersection.height > 0 && intersection.width > 0
    }
}

extension UIView {
    func scrollToTop() {
        var navigationBarHeight: CGFloat = 44

        for child in subviews {
            if let navigationBar = child as? UINavigationBar {
                navigationBarHeight = navigationBar.frame.size.height
            }
            if let scrollView = child as? UIScrollView,
                scrollView.contentOffset.y > navigationBarHeight {
                scrollView.scrollRectToVisible(CGRect(x: 0, y: -navigationBarHeight, width: 1, height: 1), animated: true)
            }
            child.scrollToTop()
        }
    }
}
