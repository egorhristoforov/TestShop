//
//  NavigationController.swift
//  TestShop
//
//  Created by Egor on 22.11.2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barTintColor = #colorLiteral(red: 0.4949728251, green: 0.3844715953, blue: 1, alpha: 1)
        navigationBar.isTranslucent = true
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = true
            navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        }
    }

}
