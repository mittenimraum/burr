//
//  UIKit+UITabBarController.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 16.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import UIKit

extension UITabBarController {
    static var delay: DispatchQueue.Delay?

    // Workaround for the missing view update when going from the
    // "more" screen of the tabbar to the selected child screen
    open override var navigationController: UINavigationController? {
        guard
            let delegate = view.window?.windowScene?.delegate as? SceneDelegate,
            selectedIndex < delegate.coordinator.store.value.hashtags.count else {
            return super.navigationController
        }
        super.children.forEach { child1 in
            child1.children.forEach { child2 in
                child2.view.backgroundColor = .white
                child2.navigationController?.setNavigationBarHidden(true, animated: false)
            }
        }
        UITabBarController.delay?.cancel()
        UITabBarController.delay = DispatchQueue.delay(0.33) { [weak self] in
            guard let index = self?.selectedIndex else {
                return
            }
            delegate.coordinator.store.dispatch(AppAction.selectIndex(index))
        }
        return super.navigationController
    }
}
