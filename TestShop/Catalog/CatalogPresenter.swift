//
//  CatalogPresenter.swift
//  TestShop
//
//  Created by Egor on 21.11.2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation
import UIKit

class CatalogPresenter: CatalogPresenterProtocol {
    
    weak var view: CatalogViewProtocol!
    var interactor: CatalogInteractorProtocol!
    var router: CatalogRouterProtocol!
    
    required init(view: CatalogViewProtocol) {
        self.view = view
    }
    
    // MARK: - AboutPresenterProtocol methods
    
    func configureView() {
        view.setupTableViewAndTabBar()
        view.setupNavigationBar()
        interactor.getProducts()
    }
    
    func updateTableViewData(with products: [Product]) {
        view.reloadTableViewData(with: products)
    }
}
