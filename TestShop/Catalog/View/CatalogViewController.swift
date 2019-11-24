//
//  CatalogViewController.swift
//  TestShop
//
//  Created by Egor on 21.11.2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import UIKit
import RxSwift

class CatalogViewController: UIViewController {
    var presenter: CatalogPresenterProtocol!
    let configurator: CatalogConfiguratorProtocol = CatalogConfigurator()
    
    let disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = #colorLiteral(red: 0.4949728251, green: 0.3844715953, blue: 1, alpha: 1)
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: "CatalogCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    private let tabBar: UITabBar = {
        let tabbar = UITabBar()
        let sushiTab = UITabBarItem(title: "Суши", image: UIImage(named: "SushiIcon"), tag: 0)
        
        let pizzaTab = UITabBarItem(title: "Пицца", image: UIImage(named: "PizzaIcon"), tag: 1)
        
        let drinksTab = UITabBarItem(title: "Напитки", image: UIImage(named: "DrinksIcon"), tag: 2)
        
        tabbar.items = [sushiTab, pizzaTab, drinksTab]
        tabbar.isExclusiveTouch = true
        tabbar.unselectedItemTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        tabbar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tabbar.barTintColor = #colorLiteral(red: 0.4949728251, green: 0.3844715953, blue: 1, alpha: 1)
        tabbar.translatesAutoresizingMaskIntoConstraints = false
        
        return tabbar
    }()
    
    private var navigationRightItem: UIBarButtonItem!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func setupTableViewAndTabBar() {
        view.addSubview(tableView)
        view.addSubview(tabBar)
        
        tabBar.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            let bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            let heightConstant:CGFloat = bottomInset + 49
            tabBar.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        }
        
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: tabBar.topAnchor).isActive = true
    }
    
    func setupNavigationBar() {
        navigationRightItem = UIBarButtonItem(title: Cart.shared().getStringValue(), style: .plain, target: self, action: #selector(navigationRightItemTapped))
        navigationRightItem.tintColor = .white
        navigationItem.rightBarButtonItem = navigationRightItem
        navigationController?.navigationBar.tintColor = .white
    }
    
}

// MARK: - CatalogViewProtocol methods

extension CatalogViewController: CatalogViewProtocol {
    func setupView() {
        view.backgroundColor = #colorLiteral(red: 0.4949728251, green: 0.3844715953, blue: 1, alpha: 1)
        title = "Каталог"
        
        tableView.delegate = self
        tableView.dataSource = self
        tabBar.delegate = self
        
        setupNavigationBar()
        setupTableViewAndTabBar()
        
        Cart.shared().summaryPrice.subscribe(onNext: { (_) in
            self.navigationRightItem.title = Cart.shared().getStringValue()
        }).disposed(by: disposeBag)
    }
    
    func reloadTableViewData() {
        tableView.reloadData()
    }
    
    func scrollTo(indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    @objc func navigationRightItemTapped() {
        presenter.navigationRightItemTapped()
    }
}

// MARK: - Tableview delegate protocol methods

extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.productsCountFor(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.countOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogCell", for: indexPath) as! CatalogTableViewCell
        let product = presenter.productForIndexPath(indexPath: indexPath)
        cell.setupCell(with: product)
        return cell
    }
    
}

// MARK: - Tableview scroll

extension CatalogViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let paths = tableView.indexPathsForVisibleRows else { return }
        guard paths.count > 0 else { return }
        
        tabBar.selectedItem = tabBar.items?[paths[paths.count / 2].section]
    }
}

// MARK: - Tabbar select item

extension CatalogViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = item.tag
        presenter.tabbarDidSelectItem(index: index)
    }
}
