//
//  CartInteractor.swift
//  TestShop
//
//  Created by Egor on 24.11.2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation

class CartInteractor: CartInteractorProtocol {
    weak var presenter: CartPresenterProtocol!
    
    required init(presenter: CartPresenterProtocol) {
        self.presenter = presenter
    }
    
    private var cartProducts: [CartProduct] = []
    
    // MARK: - CartInteractorProtocol methods
    
    func productsCountFor(section: Int) -> Int {
        return cartProducts.count
    }
    
    func productForIndexPath(indexPath: IndexPath) -> CartProduct {
        return cartProducts[indexPath.row]
    }
    
    func getCartProducts() {
        cartProducts = Cart.shared().getProducts()
        presenter.updateTableViewData()
    }
    
    func countOfSections() -> Int {
        return 1
    }
    
    func removeFromCartProduct(indexPath: IndexPath) {
        Cart.shared().removeProductFromCart(product: cartProducts[indexPath.row])
        cartProducts = Cart.shared().getProducts()
    }
}
