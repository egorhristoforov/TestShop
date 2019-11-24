//
//  CatalogTableViewCell.swift
//  TestShop
//
//  Created by Egor on 22.11.2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

class CatalogTableViewCell: UITableViewCell {
    
    private let disposeBag = DisposeBag()
    
    private var product: Product!
    private var isAddedToCart: Bool = false {
        didSet {
            if isAddedToCart {
                addToCartButton.setTitle("УБРАТЬ ИЗ КОРЗИНЫ", for: .normal)
                UIView.animate(withDuration: 0.2) {
                    self.addToCartButton.backgroundColor = UIColor.red.withAlphaComponent(0.3)
                }
            } else {
                addToCartButton.setTitle("ДОБАВИТЬ В КОРЗИНУ", for: .normal)
                UIView.animate(withDuration: 0.2) {
                    self.addToCartButton.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                }
            }
        }
    }
    
    private let cellBackroundView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9852560163, green: 0.9898150563, blue: 1, alpha: 0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let productTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        title.textColor = .white
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        
        return title
    }()
    
    private let productDescription: UILabel = {
        let description = UILabel()
        description.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        description.textColor = .white
        description.lineBreakMode = .byWordWrapping
        description.numberOfLines = 0
        description.translatesAutoresizingMaskIntoConstraints = false
        
        return description
    }()
    
    private let productPrice: UILabel = {
        let price = UILabel()
        price.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        price.textColor = .white
        price.textAlignment = .right
        price.translatesAutoresizingMaskIntoConstraints = false
        
        return price
    }()
    
    private let productImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "ProductPlaceholderImage")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
    
        return image
    }()
    
    private var productOptions: [Option] = []
    
    private var allProductOptions: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    /**
     Добавляет Свитчи и лейблы, соответствующие опциям, в allProductOptions
     */
    
    func setProductOptions(with options: [Option]) {
        
        for subview in allProductOptions.arrangedSubviews {
            allProductOptions.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        for (index, option) in options.enumerated() {
            let switchView = UISwitch()
            switchView.tag = index
            
            switches.append(switchView)
            
            if Cart.shared().isOptionAdded(product: product, option: option) {
                switchView.isOn = true
            } else {
                switchView.isOn = false
            }
            
            let optionLabel = UILabel()
            optionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            optionLabel.textColor = .white
            optionLabel.lineBreakMode = .byWordWrapping
            optionLabel.numberOfLines = 0
            optionLabel.text = option.type.getStringValue() + " - \(option.price)₽"
            optionLabel.sizeToFit()
            optionLabel.layoutIfNeeded()
            
            let stack = UIStackView(arrangedSubviews: [optionLabel, switchView])
            stack.axis = .horizontal
            stack.alignment = .center
            stack.distribution = .equalSpacing
            stack.spacing = 10
            
            allProductOptions.addArrangedSubview(stack)
        }
    }
    
    private let addToCartButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var switches: [UISwitch] = []
    
    func setupCell(with product: Product) {
        self.product = product
        isAddedToCart = Cart.shared().isContains(product: product)
        productTitle.text = product.title
        productPrice.text = "\(product.price)₽"
        productDescription.text = product.description
        
        productOptions = product.options
        
        setProductOptions(with: productOptions)
        
        for switchView in switches {
            switchView.addTarget(self, action: #selector(addOptionToCartToggle(sender:)), for: .valueChanged)
        }

        fetchImage(url_img: product.imageURL, for: productImage)
    }
    
    func addToCartButtonTapped() {
        if isAddedToCart {
            Cart.shared().removeProductFromCart(product: product)
            for switchView in switches {
                switchView.isOn = false
            }
        } else {
            Cart.shared().addProductToCart(product: product)
        }
        
        isAddedToCart = !isAddedToCart
    }
    
    @objc func addOptionToCartToggle(sender: UISwitch) {
        let index = sender.tag
        if sender.isOn {
            Cart.shared().addExtraOption(for: product, option: productOptions[index])
            if !isAddedToCart {
                isAddedToCart = true
            }
        } else {
            Cart.shared().removeExtraOption(for: product, option: productOptions[index])
        }
    }
    
    func setupConstraints() {
        addSubview(cellBackroundView)
        cellBackroundView.addSubview(productImage)
        cellBackroundView.addSubview(productTitle)
        cellBackroundView.addSubview(productDescription)
        cellBackroundView.addSubview(productPrice)
        cellBackroundView.addSubview(allProductOptions)
        cellBackroundView.addSubview(addToCartButton)
        
        cellBackroundView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        cellBackroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        cellBackroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        cellBackroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        productImage.topAnchor.constraint(equalTo: cellBackroundView.topAnchor, constant: 0).isActive = true
        productImage.leadingAnchor.constraint(equalTo: cellBackroundView.leadingAnchor, constant: 0).isActive = true
        productImage.trailingAnchor.constraint(equalTo: cellBackroundView.trailingAnchor, constant: 0).isActive = true
        productImage.bottomAnchor.constraint(equalTo: productTitle.topAnchor, constant: -20).isActive = true
        productImage.heightAnchor.constraint(equalToConstant: 200).isActive = true

        productTitle.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 20).isActive = true
        productTitle.leadingAnchor.constraint(equalTo: cellBackroundView.leadingAnchor, constant: 10).isActive = true
        productTitle.trailingAnchor.constraint(equalTo: productPrice.leadingAnchor, constant: -10).isActive = true
        productTitle.bottomAnchor.constraint(equalTo: productDescription.topAnchor, constant: -5).isActive = true
        
        productPrice.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 20).isActive = true
        productPrice.leadingAnchor.constraint(equalTo: productTitle.trailingAnchor, constant: 10).isActive = true
        productPrice.trailingAnchor.constraint(equalTo:cellBackroundView.trailingAnchor, constant: -10).isActive = true
        productPrice.bottomAnchor.constraint(equalTo: productDescription.topAnchor, constant: -5).isActive = true
        productPrice.widthAnchor.constraint(greaterThanOrEqualToConstant: 75).isActive = true

        productDescription.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: 5).isActive = true
        productDescription.leadingAnchor.constraint(equalTo: cellBackroundView.leadingAnchor, constant: 10).isActive = true
        productDescription.trailingAnchor.constraint(equalTo: cellBackroundView.trailingAnchor, constant: -10).isActive = true
        productDescription.bottomAnchor.constraint(equalTo: allProductOptions.topAnchor, constant: -20).isActive = true

        allProductOptions.topAnchor.constraint(equalTo: productDescription.bottomAnchor, constant: 20).isActive = true
        allProductOptions.leadingAnchor.constraint(equalTo: cellBackroundView.leadingAnchor, constant: 10).isActive = true
        allProductOptions.trailingAnchor.constraint(equalTo: cellBackroundView.trailingAnchor, constant: -10).isActive = true
        allProductOptions.bottomAnchor.constraint(equalTo: addToCartButton.topAnchor, constant: -20).isActive = true
        
        addToCartButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addToCartButton.topAnchor.constraint(equalTo: allProductOptions.bottomAnchor, constant: 20).isActive = true
        addToCartButton.leadingAnchor.constraint(equalTo: cellBackroundView.leadingAnchor, constant: 10).isActive = true
        addToCartButton.trailingAnchor.constraint(equalTo: cellBackroundView.trailingAnchor, constant: -10).isActive = true
        addToCartButton.bottomAnchor.constraint(equalTo: cellBackroundView.bottomAnchor, constant: -20).isActive = true
    }
    
    private func fetchImage(url_img: String, for view: UIImageView) {
        if let url = URL(string: url_img){
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    view.kf.setImage(with: url, placeholder: UIImage(named: "ProductPlaceholderImage"))
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 0.4949728251, green: 0.3844715953, blue: 1, alpha: 1)
        addToCartButton.rx
            .tap
            .asObservable()
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe { (_) in
                self.addToCartButtonTapped()
            }
            .disposed(by: disposeBag)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
