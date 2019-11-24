//
//  Entities.swift
//  TestShop
//
//  Created by Egor on 21.11.2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum Options: String, Decodable {
    case extraSauce
    case extraCheese
    case extraOnions
    case extraPepperoni
    
    func getStringValue() -> String {
        switch self {
        case .extraSauce:
            return "Дополнительный соус"
        case .extraCheese:
            return "Дополнительный сыр"
        case .extraOnions:
            return "Дополнительный лук"
        case .extraPepperoni:
            return "Дополнительные пепперони"
        }
    }
}

enum Categories: String, Decodable {
    case sushi
    case pizza
    case drinks
    
    func getStringValue() -> String {
        switch self {
        case .drinks:
            return "Напитки"
        case .pizza:
            return "Пицца"
        case .sushi:
            return "Суши"
        }
    }
    
    func getImage() -> UIImage? {
        switch self {
        case .drinks:
            return UIImage(named: "DrinksIcon")
        case .pizza:
            return UIImage(named: "PizzaIcon")
        case .sushi:
            return UIImage(named: "SushiIcon")
        }
    }
}

struct Option: Decodable {
    let type: Options
    let price: Int
}

struct Product: Decodable {
    let id: Int
    let options: [Option]
    let imageURL: String
    let title: String
    let price: Int
    let description: String
    let category: Categories
}

struct ResponseProducts: Decodable {
    var products: [Product]
}

class CartProduct {
    var selectedId: Int
    var selectedOptions: [Option]
    var selectedImageURL: String
    var selectedTitle: String
    var selectedPrice: Int
    var selectedDescription: String
    var selectedCategory: Categories
    
    init(product: Product) {
        selectedId = product.id
        selectedOptions = []
        selectedImageURL = product.imageURL
        selectedTitle = product.title
        selectedPrice = product.price
        selectedDescription = product.description
        selectedCategory = product.category
    }
    
    func addToSelectedOptions(option: Option) {
        selectedOptions.append(option)
    }
    
    func removeOptionFromSelected(option: Option) {
        if let index = selectedOptions.firstIndex(where: { (opt) -> Bool in
            opt.type == option.type
        }) {
            selectedOptions.remove(at: index)
        }
    }
    
    func isOptionAdded(option: Option) -> Bool {
        return selectedOptions.contains { (opt) -> Bool in
            opt.type == option.type
        }
    }
}

class Cart {
    var productsCount = BehaviorRelay(value: 0)
    var summaryPrice = BehaviorRelay(value: 0)
    
    func getStringValue() -> String {
        if productsCount.value == 0 {
            return "Корзина пустая"
        }
        
        return "Корзина (\(productsCount.value)): \(summaryPrice.value) ₽"
    }
    
    private static var uniqueInstance: Cart?
    private init() {}
    
    static func shared() -> Cart {
        if uniqueInstance == nil {
            uniqueInstance = Cart()
        }
        
        return uniqueInstance!
    }
    
    func addProductToCart(product: Product) {
        selectedProducts.append(CartProduct(product: product))
        productsCount.accept(productsCount.value + 1)
        summaryPrice.accept(summaryPrice.value + product.price)
    }
    
    func removeProductFromCart(product: Product) {
        if let index = selectedProducts.firstIndex(where: { (p) -> Bool in
            p.selectedId == product.id
        }) {
            for option in selectedProducts[index].selectedOptions {
                summaryPrice.accept(summaryPrice.value - option.price)
            }
            selectedProducts.remove(at: index)
            productsCount.accept(productsCount.value - 1)
            summaryPrice.accept(summaryPrice.value - product.price)
        }
    }
    
    func removeProductFromCart(product: CartProduct) {
        if let index = selectedProducts.firstIndex(where: { (p) -> Bool in
            p.selectedId == product.selectedId
        }) {
            for option in selectedProducts[index].selectedOptions {
                summaryPrice.accept(summaryPrice.value - option.price)
            }
            selectedProducts.remove(at: index)
            productsCount.accept(productsCount.value - 1)
            summaryPrice.accept(summaryPrice.value - product.selectedPrice)
        }
    }
    
    func addExtraOption(for product: Product, option: Option) {
        if let index = selectedProducts.firstIndex(where: { (prod) -> Bool in
            prod.selectedId == product.id
        }) {
            selectedProducts[index].addToSelectedOptions(option: option)
            summaryPrice.accept(summaryPrice.value + option.price)
        } else {
            addProductToCart(product: product)
            if let index = selectedProducts.firstIndex(where: { (prod) -> Bool in
                prod.selectedId == product.id
            }) {
                selectedProducts[index].addToSelectedOptions(option: option)
                summaryPrice.accept(summaryPrice.value + option.price)
            }
        }
    }
    
    func removeExtraOption(for product: Product, option: Option) {
        if let index = selectedProducts.firstIndex(where: { (prod) -> Bool in
            prod.selectedId == product.id
        }) {
            if selectedProducts[index].isOptionAdded(option: option) {
                selectedProducts[index].removeOptionFromSelected(option: option)
                summaryPrice.accept(summaryPrice.value - option.price)
            }
        }
    }
    
    func getProducts() -> [CartProduct] {
        return selectedProducts
    }
    
    func isContains(product: Product) -> Bool {
        return selectedProducts.contains { (p) -> Bool in
            p.selectedId == product.id
        }
    }
    
    func isOptionAdded(product: Product, option: Option) -> Bool {
        if let index = selectedProducts.firstIndex(where: { (prod) -> Bool in
            prod.selectedId == product.id
        }) {
            return selectedProducts[index].isOptionAdded(option: option)
        }
        
        return false
    }
    
    private var selectedProducts: [CartProduct] = []
}



