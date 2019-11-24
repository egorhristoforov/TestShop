//
//  Entities.swift
//  TestShop
//
//  Created by Egor on 21.11.2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum OptionType: String, Decodable {
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

enum ProductCategory: String, Decodable {
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
    
    /**
     Метод для получения изображения категории ( для таббара )
     */
    
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
    let type: OptionType
    let price: Int
}

struct Product: Decodable {
    let id: Int
    let options: [Option]
    let imageURL: String
    let title: String
    let price: Int
    let description: String
    let category: ProductCategory
}

struct ResponseProducts: Decodable {
    var products: [Product]
}

class CartProduct {
    private let disposeBag = DisposeBag()
    
    var selectedId: Int
    var selectedOptions: BehaviorRelay<[Option]> = BehaviorRelay(value: [])
    var selectedImageURL: String
    var selectedTitle: String
    var selectedPrice: Int
    var selectedDescription: String
    var selectedCategory: ProductCategory
    var portionsCount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var summaryProductPrice: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    init(product: Product) {
        selectedId = product.id
        selectedOptions.accept([])
        selectedImageURL = product.imageURL
        selectedTitle = product.title
        selectedPrice = product.price
        selectedDescription = product.description
        selectedCategory = product.category
        portionsCount.accept(1)
        summaryProductPrice.accept(product.price)
        
        selectedOptions.subscribe(onNext: { (options) in
            var price = self.selectedPrice
            for option in options {
                price += option.price
            }
            price = price * self.portionsCount.value
            
            self.summaryProductPrice.accept(price)
            }).disposed(by: disposeBag)
        
        portionsCount.subscribe(onNext: { (count) in
            var price = self.selectedPrice
            for option in self.selectedOptions.value {
                price += option.price
            }
            price = price * count
            
            self.summaryProductPrice.accept(price)
            }).disposed(by: disposeBag)
    }
    
    func addToSelectedOptions(option: Option) {
        selectedOptions.accept(selectedOptions.value + [option])
    }
    
    func removeOptionFromSelected(option: Option) {
        if let index = selectedOptions.value.firstIndex(where: { (opt) -> Bool in
            opt.type == option.type
        }) {
            var allOptions = selectedOptions.value
            allOptions.remove(at: index)
            selectedOptions.accept(allOptions)
        }
    }
    
    func isOptionAdded(option: Option) -> Bool {
        return selectedOptions.value.contains { (opt) -> Bool in
            opt.type == option.type
        }
    }
}

class Cart {
    private var disposeBag = DisposeBag()
    
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
        let cartProduct = CartProduct(product: product)
        selectedProducts.append(cartProduct)
        cartProduct.summaryProductPrice.subscribe(onNext: { (_) in
            var price = 0
            var count = 0
            for prod in self.selectedProducts {
                price += prod.summaryProductPrice.value
                count += prod.portionsCount.value
            }
            self.productsCount.accept(count)
            self.summaryPrice.accept(price)
            }).disposed(by: disposeBag)
    }
    
    func removeProductFromCart(product: Product) {
        if let index = selectedProducts.firstIndex(where: { (p) -> Bool in
            p.selectedId == product.id
        }) {
            productsCount.accept(productsCount.value - selectedProducts[index].portionsCount.value)
            summaryPrice.accept(summaryPrice.value - selectedProducts[index].summaryProductPrice.value)
            selectedProducts.remove(at: index)
        }
    }
    
    func removeProductFromCart(product: CartProduct) {
        if let index = selectedProducts.firstIndex(where: { (p) -> Bool in
            p.selectedId == product.selectedId
        }) {
            productsCount.accept(productsCount.value - product.portionsCount.value)
            summaryPrice.accept(summaryPrice.value - product.summaryProductPrice.value)
            selectedProducts.remove(at: index)
        }
    }
    
    func addExtraOption(for product: Product, option: Option) {
        if let index = selectedProducts.firstIndex(where: { (prod) -> Bool in
            prod.selectedId == product.id
        }) {
            selectedProducts[index].addToSelectedOptions(option: option)
        } else {
            addProductToCart(product: product)
            if let index = selectedProducts.firstIndex(where: { (prod) -> Bool in
                prod.selectedId == product.id
            }) {
                selectedProducts[index].addToSelectedOptions(option: option)
            }
        }
    }
    
    func removeExtraOption(for product: Product, option: Option) {
        if let index = selectedProducts.firstIndex(where: { (prod) -> Bool in
            prod.selectedId == product.id
        }) {
            if selectedProducts[index].isOptionAdded(option: option) {
                selectedProducts[index].removeOptionFromSelected(option: option)
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



