//
//  CartPresenter.swift
//  TestShop
//
//  Created by Egor on 24.11.2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation

class CartPresenter: CartPresenterProtocol {
    weak var view: CartViewProtocol!
    var interactor: CartInteractorProtocol!
    
    required init(view: CartViewProtocol) {
        self.view = view
    }
    
    // MARK: - CartPresenterProtocol methods
    
    func configureView() {
        view.setupView()
        interactor.getCartProducts()
    }
    
    func updateTableViewData() {
        view.reloadTableViewData()
    }
    
    func productsCountFor(section: Int) -> Int {
        return interactor.productsCountFor(section: section)
    }
    
    func productForIndexPath(indexPath: IndexPath) -> CartProduct {
        return interactor.productForIndexPath(indexPath: indexPath)
    }
    
    func countOfSections() -> Int {
        return interactor.countOfSections()
    }
    
    func removeFromCartProduct(indexPath: IndexPath) {
        interactor.removeFromCartProduct(indexPath: indexPath)
    }
}
