//
//  CatalogRouter.swift
//  TestShop
//
//  Created by Egor on 21.11.2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation

class CatalogRouter: CatalogRouterProtocol {
    func configure(with viewController: CatalogViewController) {
        //
    }
    
    
    weak var viewController: CatalogViewController!
    
    init(viewController: CatalogViewController) {
        self.viewController = viewController
    }
    
    func closeCurrentViewController() {
        viewController.dismiss(animated: true, completion: nil)
    }
}
