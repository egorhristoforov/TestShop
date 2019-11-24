//
//  CatalogRouter.swift
//  TestShop
//
//  Created by Egor on 21.11.2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation

class CatalogRouter: CatalogRouterProtocol {
    
    weak var viewController: CatalogViewController!
    
    init(viewController: CatalogViewController) {
        self.viewController = viewController
    }
    
    // MARK: - CatalogRouterProtocol methods
    
    func goToCartVC() {
        viewController.navigationController?.pushViewController(CartViewController(), animated: true)
    }
}
