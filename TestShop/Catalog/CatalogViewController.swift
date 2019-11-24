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
    
    private var sushiProducts: [Product] = []
    private var pizzaProducts: [Product] = []
    private var drinksProducts: [Product] = []
    
    private var navigationRightItem: UIBarButtonItem!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tabBar.delegate = self

        Cart.shared().summaryPrice.subscribe(onNext: { (price) in
            self.navigationRightItem.title = Cart.shared().getStringValue()
        }).disposed(by: disposeBag)
        
        view.backgroundColor = #colorLiteral(red: 0.4949728251, green: 0.3844715953, blue: 1, alpha: 1)
        title = "Каталог"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Interactor handlers
    
    func scrollTableViewToSushi() {
        guard sushiProducts.count > 0 else { return }
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func scrollTableViewToPizza() {
        guard pizzaProducts.count > 0 else { return }
        let indexPath = IndexPath(row: 0, section: 1)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func scrollTableViewToDrinks() {
        guard drinksProducts.count > 0 else { return }
        let indexPath = IndexPath(row: 0, section: 2)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    @objc func goToCartViewController() {
        let vc = CartViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - CatalogViewProtocol methods

extension CatalogViewController: CatalogViewProtocol {
    
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
        navigationRightItem = UIBarButtonItem(title: Cart.shared().getStringValue(), style: .plain, target: self, action: #selector(goToCartViewController))
        navigationRightItem.tintColor = .white
        navigationItem.rightBarButtonItem = navigationRightItem
        navigationController?.navigationBar.tintColor = .white
    }
    
    func reloadTableViewData(with products: [Product]) {
        self.products = products
        if sushiProducts.count > 0 {
            tabBar.selectedItem = tabBar.items?[0]
        } else if pizzaProducts.count > 0 {
            tabBar.selectedItem = tabBar.items?[1]
        } else if drinksProducts.count > 0 {
            tabBar.selectedItem = tabBar.items?[2]
        }
        
        tableView.reloadData()
    }
}

// MARK: - Tableview delegate protocol methods

extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogCell", for: indexPath) as! CatalogTableViewCell
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
        switch index {
        case 0:
            scrollTableViewToSushi()
        case 1:
            scrollTableViewToPizza()
        case 2:
            scrollTableViewToDrinks()
        default:
            break
        }
    }
}

//extension CatalogViewController: CartDelegate {
//    func updateCartInformation() {
//        navigationRightItem.title = Cart.shared().getStringValue()
//    }
//}
