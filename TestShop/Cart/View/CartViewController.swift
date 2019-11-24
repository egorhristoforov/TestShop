//
//  CartViewController.swift
//  TestShop
//
//  Created by Egor on 23.11.2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import UIKit
import RxSwift

class CartViewController: UIViewController {
    
    var presenter: CartPresenterProtocol!
    let configurator: CartConfiguratorProtocol = CartConfigurator()
    
    let disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = #colorLiteral(red: 0.4949728251, green: 0.3844715953, blue: 1, alpha: 1)
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    private let orderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Оформить заказ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
    }
    
    func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(orderButton)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: orderButton.topAnchor, constant: -10).isActive = true
        
        var bottomInset = CGFloat(0)
        if #available(iOS 11.0, *) {
            bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            
        }
        
        orderButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        orderButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10).isActive = true
        orderButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        orderButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        orderButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20 - bottomInset).isActive = true
    }

}

extension CartViewController: CartViewProtocol {
    func setupView() {
        view.backgroundColor = #colorLiteral(red: 0.4949728251, green: 0.3844715953, blue: 1, alpha: 1)
        title = "Корзина"
        tableView.delegate = self
        tableView.dataSource = self
        
        setupConstraints()
        
        if Cart.shared().productsCount.value == 0 {
            orderButton.setTitle("Корзина пустая", for: .normal)
        }
        
        Cart.shared().summaryPrice.subscribe(onNext: { (price) in
            if price > 0 {
                self.orderButton.setTitle("Оформить заказ: \(price)₽", for: .normal)
            } else {
                self.orderButton.setTitle("Корзина пустая", for: .normal)
            }
            }).disposed(by: disposeBag)
    }
    
    func reloadTableViewData() {
        tableView.reloadData()
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.productsCountFor(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.countOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        let product = presenter.productForIndexPath(indexPath: indexPath)
        cell.setupCell(with: product)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.removeFromCartProduct(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Убрать из корзины"
    }
    
}
