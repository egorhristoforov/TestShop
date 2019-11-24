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
    
    // MARK: - CatalogPresenterProtocol methods
    
    // MARK: - From view
    
    func configureView() {
        view.setupView()
        interactor.getProducts()
    }
    
    func productsCountFor(section: Int) -> Int {
        return interactor.productsCountFor(section: section)
    }
    
    func countOfSections() -> Int{
        return interactor.countOfSections()
    }
    
    func productForIndexPath(indexPath: IndexPath) -> Product {
        return interactor.productForIndexPath(indexPath: indexPath)
    }
    
    func navigationRightItemTapped() {
        router.goToCartVC()
    }
    
    func tabbarDidSelectItem(index: Int) {
        interactor.tabbarDidSelectItem(index: index)
    }
    
    //MARK: - From interactor
    
    func scrollTableViewTo(indexPath: IndexPath) {
        view.scrollTo(indexPath: indexPath)
    }
    
    func updateTableViewData(with tabs: [ProductCategory]) {
        view.reloadTableViewData(with: tabs)
    }
}
