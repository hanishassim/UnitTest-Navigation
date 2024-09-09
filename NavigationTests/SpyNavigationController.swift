//
//  SpyNavigationController.swift
//  NavigationTests
//
//  Created by Hassim, Muhammad Hanis on 09/09/2024.
//

import UIKit

class SpyNavigationController: UINavigationController {
    
    private(set) var pushViewControllerArgsAnimated: [Bool] = []

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        pushViewControllerArgsAnimated.append(animated)
    }

}
