//
//  CatalogInteractor.swift
//  TestShop
//
//  Created by Egor on 21.11.2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation

class CatalogInteractor: CatalogInteractorProtocol {
    weak var presenter: CatalogPresenterProtocol!
    
    required init(presenter: CatalogPresenterProtocol) {
        self.presenter = presenter
    }
    
    private var products: [Product] = [] {
        didSet {
            sushiProducts = products.filter({ (product) -> Bool in
                product.category == .sushi
            })
            
            pizzaProducts = products.filter({ (product) -> Bool in
                product.category == .pizza
            })
            
            drinksProducts = products.filter({ (product) -> Bool in
                product.category == .drinks
            })
        }
    }
    
    var sushiProducts: [Product] = []
    var pizzaProducts: [Product] = []
    var drinksProducts: [Product] = []
    
    // MARK: - CatalogInteractorProtocol methods
    
    func getProducts() {
        DataLoader.downloadProducts { (response) in
            self.products = response.products
            self.presenter.updateTableViewData()
        }
    }
    
    func tabbarDidSelectItem(index: Int) {
        var indexPath: IndexPath
        switch index {
        case 0:
            guard sushiProducts.count > 0 else { return }
            indexPath = IndexPath(row: 0, section: 0)
        case 1:
            guard pizzaProducts.count > 0 else { return }
            indexPath = IndexPath(row: 0, section: 1)
        case 2:
            guard drinksProducts.count > 0 else { return }
            indexPath = IndexPath(row: 0, section: 2)
        default:
            return
        }
        
        presenter.scrollTableViewTo(indexPath: indexPath)
    }
    
    func productsCountFor(section: Int) -> Int {
        switch section {
        case 0:
            return sushiProducts.count
        case 1:
            return pizzaProducts.count
        case 2:
            return drinksProducts.count
        default:
            return 0
        }
    }
    
    func countOfSections() -> Int {
        return 3
    }
    
    func productForIndexPath(indexPath: IndexPath) -> Product {
        var product: Product = Product(id: -1, options: [], imageURL: "", title: "", price: 0, description: "", category: .drinks)
        
        switch indexPath.section {
        case 0:
            product = sushiProducts[indexPath.row]
        case 1:
            product = pizzaProducts[indexPath.row]
        case 2:
            product = drinksProducts[indexPath.row]
        default:
            break
        }
        
        return product
    }
}
