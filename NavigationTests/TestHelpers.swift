//
//  TestHelpers.swift
//  NavigationTests
//
//  Created by Hassim, Muhammad Hanis on 09/09/2024.
//

import UIKit

func tap(_ button: UIButton) {
    button.sendActions(for: .touchUpInside)
}

func executeRunLoop() {
    RunLoop.current.run(until: Date())
}
