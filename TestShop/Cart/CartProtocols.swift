//
//  CartProtocols.swift
//  TestShop
//
//  Created by Egor on 24.11.2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation
import UIKit

protocol CartViewProtocol: class {
    func setupView()
    func reloadTableViewData()
}

protocol CartPresenterProtocol: class {
    func configureView()
    func updateTableViewData()
    func productsCountFor(section: Int) -> Int
    func productForIndexPath(indexPath: IndexPath) -> CartProduct
    func countOfSections() -> Int
    func removeFromCartProduct(indexPath: IndexPath)
}

protocol CartInteractorProtocol: class {
    func getCartProducts()
    func productsCountFor(section: Int) -> Int
    func productForIndexPath(indexPath: IndexPath) -> CartProduct
    func countOfSections() -> Int
    func removeFromCartProduct(indexPath: IndexPath)
}

protocol CartConfiguratorProtocol: class {
    func configure(with viewController: CartViewController)
}
