//
//  CartTableViewCell.swift
//  TestShop
//
//  Created by Egor on 23.11.2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
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
    
    private let productPrice: UILabel = {
        let price = UILabel()
        price.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        price.textColor = .white
        price.textAlignment = .right
        price.translatesAutoresizingMaskIntoConstraints = false
        
        return price
    }()
    
    private let productOptionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let productStepper: CartProductStepper = {
        let stepper = CartProductStepper()
        stepper.maximumValue = 4
        stepper.minimumValue = 1
        stepper.translatesAutoresizingMaskIntoConstraints = false
        
        return stepper
    }()
    
    func setupCell(with product: CartProduct) {
        productTitle.text = product.selectedTitle
        
        var summaryPrice = product.selectedPrice
        var allOptions = ""
        for option in product.selectedOptions {
            summaryPrice += option.price
            allOptions += "- \(option.type.getStringValue())\n"
        }
        productPrice.text = "\(summaryPrice)₽"
        productOptionsLabel.text = allOptions
    }
    
    func setupConstraints() {
        addSubview(cellBackroundView)
        cellBackroundView.addSubview(productTitle)
        cellBackroundView.addSubview(productPrice)
        cellBackroundView.addSubview(productOptionsLabel)
        cellBackroundView.addSubview(productStepper)
        
        cellBackroundView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        cellBackroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        cellBackroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        cellBackroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true

        productTitle.topAnchor.constraint(equalTo: cellBackroundView.topAnchor, constant: 20).isActive = true
        productTitle.leadingAnchor.constraint(equalTo: cellBackroundView.leadingAnchor, constant: 10).isActive = true
        productTitle.trailingAnchor.constraint(equalTo: productPrice.leadingAnchor, constant: -10).isActive = true
        productTitle.bottomAnchor.constraint(equalTo: productOptionsLabel.topAnchor, constant: -5).isActive = true
        
        productPrice.topAnchor.constraint(equalTo: cellBackroundView.topAnchor, constant: 20).isActive = true
        productPrice.leadingAnchor.constraint(equalTo: productTitle.trailingAnchor, constant: 10).isActive = true
        productPrice.trailingAnchor.constraint(equalTo:cellBackroundView.trailingAnchor, constant: -10).isActive = true
        productPrice.bottomAnchor.constraint(equalTo: productOptionsLabel.topAnchor, constant: -5).isActive = true
        productPrice.widthAnchor.constraint(greaterThanOrEqualToConstant: 75).isActive = true

        productOptionsLabel.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: 5).isActive = true
        productOptionsLabel.leadingAnchor.constraint(equalTo: cellBackroundView.leadingAnchor, constant: 10).isActive = true
        productOptionsLabel.trailingAnchor.constraint(equalTo: cellBackroundView.trailingAnchor, constant: -10).isActive = true
        productOptionsLabel.bottomAnchor.constraint(equalTo: productStepper.topAnchor, constant: -10).isActive = true
        
        productStepper.topAnchor.constraint(equalTo: productOptionsLabel.bottomAnchor, constant: 10).isActive = true
        productStepper.leadingAnchor.constraint(equalTo: cellBackroundView.leadingAnchor, constant: 10).isActive = true
        productStepper.trailingAnchor.constraint(equalTo: cellBackroundView.trailingAnchor, constant: -10).isActive = true
        productStepper.bottomAnchor.constraint(equalTo: cellBackroundView.bottomAnchor, constant: -20).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 0.4949728251, green: 0.3844715953, blue: 1, alpha: 1)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
