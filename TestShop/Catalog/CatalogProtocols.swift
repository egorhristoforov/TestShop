//
//  CatalogProtocols.swift
//  TestShop
//
//  Created by Egor on 21.11.2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation
import UIKit

protocol CatalogViewProtocol: class {
    func setupView()
    func reloadTableViewData()
    func scrollTo(indexPath: IndexPath)
}

protocol CatalogPresenterProtocol: class {
    var router: CatalogRouterProtocol! { set get }
    func configureView()
    func updateTableViewData()
    func navigationRightItemTapped()
    func tabbarDidSelectItem(index: Int)
    func scrollTableViewTo(indexPath: IndexPath)
    func productsCountFor(section: Int) -> Int
    func countOfSections() -> Int
    func productForIndexPath(indexPath: IndexPath) -> Product
}

protocol CatalogInteractorProtocol: class {
    func getProducts()
    func tabbarDidSelectItem(index: Int)
    func productsCountFor(section: Int) -> Int
    func countOfSections() -> Int
    func productForIndexPath(indexPath: IndexPath) -> Product
}

protocol CatalogRouterProtocol: class {
    func goToCartVC()
}

protocol CatalogConfiguratorProtocol: class {
    func configure(with viewController: CatalogViewController)
}
