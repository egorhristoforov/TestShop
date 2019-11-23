//
//  CatalogConfigurator.swift
//  TestShop
//
//  Created by Egor on 21.11.2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation

class CatalogConfigurator: CatalogConfiguratorProtocol {
    
    func configure(with viewController: CatalogViewController) {
        let presenter = CatalogPresenter(view: viewController)
        let interactor = CatalogInteractor(presenter: presenter)
        let router = CatalogRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
