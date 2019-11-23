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
    
    var urlRatesSource: String {
        get {
            //return serverService.urlRatesSource
            return "url string"
        }
    }
    
    var products: [Product] = [] {
        didSet {
            presenter.updateTableViewData(with: products)
        }
    }
    
    func getProducts() {
        DataLoader.downloadProducts { (response) in
            self.products = response.products
        }
    }
    
    func openUrl(with urlString: String) {
        //serverService.openUrl(with: urlString)
    }
}
