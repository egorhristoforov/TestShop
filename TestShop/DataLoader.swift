//
//  DataLoader.swift
//  TestShop
//
//  Created by Egor on 21.11.2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import Foundation
import Alamofire

let SERVER_URL = "https://server.url/api/"
let REQUEST_PRODUCTS = "get_products_endpoint/"

class DataLoader {
    static func downloadProducts(completion:@escaping ((_ result: ResponseProducts) -> Void)) {
        /**
         * Получение данных из ProductsData.json
         */
        var products = ResponseProducts(products: [])

        let dataURL = Bundle.main.url(forResource: "ProductsData", withExtension: "json")
        let task = URLSession.shared.dataTask(with: dataURL!){  (data, response, error) -> Void in
            guard let dataResponse = data, error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return
            }

            do{
                let decoder = JSONDecoder()
                products = try decoder.decode(ResponseProducts.self, from: dataResponse)
            } catch let parsingError {
                print("Error", parsingError)
            }
            OperationQueue.main.addOperation {
                completion(products)
            }
        }
        task.resume()
        
        /* Получение товара с сервера
        let headers = ["Content-Type": "application/json"]
        Alamofire.request(SERVER_URL + REQUEST_PRODUCTS,
                          method: .post,
                          parameters: [:],
                          encoding: JSONEncoding.default,
                          headers: headers).validate().responseData { response in
                            switch response.result {
                            case .success:
                                if let data = response.data {
                                    do{
                                        let decoder = JSONDecoder()
                                        products = try decoder.decode(ResponseProducts.self, from: data)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            case .failure(_):
                                print("Failed get products")
                            }
                            OperationQueue.main.addOperation {
                                completion(products)
                            }
        } */
    }
}
