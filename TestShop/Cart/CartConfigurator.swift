//
//  CartConfigurator.swift
//  TestShop
//
//  Created by Egor on 24.11.2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation

class CartConfigurator: CartConfiguratorProtocol {
    
    func configure(with viewController: CartViewController) {
        let presenter = CartPresenter(view: viewController)
        let interactor = CartInteractor(presenter: presenter)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
    }
}
