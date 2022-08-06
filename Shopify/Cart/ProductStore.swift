//
//  ProductStore.swift
//  BasicStructure
//
//  Created by Ibrahem's on 13/07/2022.
//
//
//import UIKit
//
//class ProductStore {
//
//    var products = [OrdersInCart]()
//
//    func getPositionByName(itemName: String) -> Int? {
//        for i in 0...products.count-1 {
//            if products[i].itemName == itemName {
//                return i
//            }
//        }
//        return nil
//    }
//
//    func getPriceByName(itemName: String) -> String? {
//        for product in products {
//            if product.itemName == itemName {
//                return product.itemPrice
//            }
//        }
//        return nil
//    }
//
//    func calculateTotal() -> Double {
//        var totalValue: Double = 0
//
//        for product in products {
//            totalValue += Double(product.itemQuantity) * (Double(product.itemPrice!) ?? 0.0)
//        }
//
//        return totalValue
//    }
//}
//


//class ProductStore {
//
//    var products = [OrdersInCart]()
//
//    func getPositionByName(itemName: String) -> Int? {
//        for i in 0...products.count-1 {
//            if products[i].itemName == itemName {
//                return i
//            }
//        }
//        return nil
//    }
//
//    func getPriceByName(title: String) -> String? {
//        for product in products {
//            if product.itemPrice == title {
//                return product.itemPrice
//            }
//        }
//        return nil
//    }
//
//    func calculateTotal() -> Double {
//        var totalValue: Double = 0
//
//        for product in products {
//            totalValue += Double(product.itemQuantity) * product.itemPrice
//        }
//
//        return totalValue
//    }

import UIKit

class Item {
    
    var title: String
    var price: Double
    var image: UIImage
    var quantity: Int
    
    init(title: String, price: Double, image: UIImage, quantity: Int) {
        self.title = title
        self.price = price
        self.image = image
        self.quantity = quantity
    }
    
    func setQuantity (quantity: Int) {
        self.quantity = quantity
    }
}

class ProductStore {
    
    var products: [Item] = [
        Item(title: "iPad Pro", price: 599, image: #imageLiteral(resourceName: "img_ipad"), quantity: 0),
        Item(title: "Apple Watch", price: 299, image: #imageLiteral(resourceName: "img_watch") , quantity: 0),
        Item(title: "Apple TV", price: 199, image: #imageLiteral(resourceName: "img_tv") , quantity: 0)
    ]
    
    func getPositionByName(title: String) -> Int? {
        for i in 0...products.count-1 {
            if products[i].title == title {
                return i
            }
        }
        return nil
    }
    
    func getPriceByName(title: String) -> Double? {
        for product in products {
            if product.title == title {
                return product.price
            }
        }
        return nil
    }
    
    func calculateTotal() -> Double {
        var totalValue: Double = 0
        
        for product in products {
            totalValue += Double(product.quantity) * product.price
        }
        
        return totalValue
    }
}
