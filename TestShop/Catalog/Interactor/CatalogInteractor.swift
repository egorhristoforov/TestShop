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
    
    private var availableCategories: [Categories] = []
    
    // MARK: - CatalogInteractorProtocol methods
    
    func getProducts() {
        DataLoader.downloadProducts { (response) in
            self.products = response.products
            if self.sushiProducts.count > 0 {
                self.availableCategories.append(.sushi)
            }
            
            if self.pizzaProducts.count > 0 {
                self.availableCategories.append(.pizza)
            }
            
            if self.drinksProducts.count > 0 {
                self.availableCategories.append(.drinks)
            }
            self.presenter.updateTableViewData(with: self.availableCategories)
        }
    }
    
    func tabbarDidSelectItem(index: Int) {
        let indexPath = IndexPath(row: 0, section: index)
        presenter.scrollTableViewTo(indexPath: indexPath)
    }
    
    func productsCountFor(section: Int) -> Int {
        let type = availableCategories[section]
        switch type {
        case .sushi:
            return sushiProducts.count
        case .pizza:
            return pizzaProducts.count
        case .drinks:
            return drinksProducts.count
        }
    }
    
    func countOfSections() -> Int {
        return availableCategories.count
    }
    
    func productForIndexPath(indexPath: IndexPath) -> Product {
        var product: Product = Product(id: -1, options: [], imageURL: "", title: "", price: 0, description: "", category: .drinks)
        
        let type = availableCategories[indexPath.section]
        switch type {
        case .sushi:
            product = sushiProducts[indexPath.row]
        case .pizza:
            product = pizzaProducts[indexPath.row]
        case .drinks:
            product = drinksProducts[indexPath.row]
        }
        
        return product
    }
}
