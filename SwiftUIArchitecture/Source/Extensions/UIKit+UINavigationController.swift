//
//  UIKit+UINavigationController.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 17.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    static var tapGestureRecognizer: UITapGestureRecognizer!

    open override func viewDidLoad() {
        super.viewDidLoad()

        Self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navigationBarTapped(_:)))
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationBar.addGestureRecognizer(Self.tapGestureRecognizer)

        Self.tapGestureRecognizer.cancelsTouchesInView = false
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationBar.removeGestureRecognizer(Self.tapGestureRecognizer)
    }

    @objc func navigationBarTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: navigationBar)
        let hitView = navigationBar.hitTest(location, with: nil)

        guard !(hitView is UIControl) else {
            return
        }
        view.scrollToTop()
    }
}
