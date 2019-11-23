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
    func setupTableViewAndTabBar()
    func reloadTableViewData(with products: [Product])
    func setupNavigationBar()
}

protocol CatalogPresenterProtocol: class {
    var router: CatalogRouterProtocol! { set get }
    func configureView()
    func updateTableViewData(with products: [Product])
}

protocol CatalogInteractorProtocol: class {
    var urlRatesSource: String { get }
    func openUrl(with urlString: String)
    func getProducts()
}

protocol CatalogRouterProtocol: class {
    func closeCurrentViewController()
}

protocol CatalogConfiguratorProtocol: class {
    func configure(with viewController: CatalogViewController)
}

protocol CartDelegate {
    func updateCartInformation()
}
