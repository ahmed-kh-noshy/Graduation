//
//  CartViewModel.swift
//  BasicStructure
//
//  Created by Ibrahem's on 15/07/2022.
//

import Foundation
import UIKit


class CartViewModel{
 
    let db = DBManager.sharedInstance
    let networking = NetworkManger()
    
    var orderProduct : [OrderItem] = []
    var totalOrder = Order()
    
   // var mathFunction: (Int, Int) -> Int = add
    var checkIfItemInCart : (()->()) = {}
    var deleteItemFromCart : (()->()) = {}
    var checkForEmptyCart : (()->()) = {}
 
    let customerID = Manager.shared.getUserID()

    var checkIfItemExist : (()->()) {
        self.checkIfItemInCart
    }
    var showDeleteAlert : (()->()) {
        self.deleteItemFromCart
    }
    var showEmptyCartAlert : (()->()) {
        self.checkForEmptyCart
    }
 //MARK: - Setup Functions Of Cart Items In Core Data
    func addItemsToCart(product:Product){
        do {
            let retrievedItems = try context.fetch(OrdersInCart.fetchRequest())
            if checkIfItemExist(itemId: product.id,items: retrievedItems){
                print("Already in cart")
                self.checkIfItemExist()
            }else{
                let orderItem = OrdersInCart(context: context)
                orderItem.itemID = Int64(product.id)
                orderItem.itemName = product.title
                orderItem.itemPrice = product.variants[0].price
                orderItem.itemImage = product.image.src
                orderItem.itemQuantity = 1
                orderItem.userID = Int64(customerID!)
                try? context.save()
                print(orderItem)
            }
        } catch let error {
            print(error)
        }
    }
    
    func checkIfItemExist(itemId: Int,items:[OrdersInCart]) -> Bool {
        var check : Bool = false
        for item in items {
            if item.itemID == itemId {
                check = true
            }else {
                check = false
            }
        }
        return check
    }
    
    
    
    func getItemsInCart(completion: @escaping (([OrdersInCart]?,Error?)->Void)){
        do {
            let cartItems = try context.fetch(OrdersInCart.fetchRequest())
            completion(cartItems, nil)
            
        } catch let error {
            completion(nil, error)
        }
    }
    func deleteFromCoreData(indexPath:IndexPath,cartItems:[OrdersInCart]){
        context.delete(cartItems[indexPath.row])
        try? context.save()
    }
}

//MARK: - Get Order Depending On Logged In (Customer ID)
extension CartViewModel{
    
    func getSelectedItemInCart(productId: Int64, completion: @escaping (OrdersInCart?, Error?)-> Void){
        getItemsInCart { orders, error in
            if error == nil {
                guard let orders = orders, let customerID = self.customerID else { return }
                for item in orders {
                    if item.itemID == productId && item.userID == customerID {
                        completion(item, nil)
                    }
                }
            }else{
                completion(nil, error)
            }
        }
    }

    
    func getSelectedProducts(completion: @escaping ([OrdersInCart]?, Error?) -> Void){
        guard let customerID = Manager.shared.getUserID() else {return}
        db.getCartProductForSelectedCustomer(customerID: customerID) { orders, error in
            guard let orders = orders, error == nil else {
                completion(nil, error)
                return
            }
            completion(orders, nil)
        }
    }
}
//MARK: - Add To CoreData
extension CartViewModel{
    func saveProductToCart(){
        db.saveToCoreData { saveSuccess in
            if saveSuccess{
                print("success to save product in cart")
            }else{
                print("failed to save product in cart")
            }
        }
    }
}
//MARK: - Calculate Total Price
extension CartViewModel{
    func calcTotalPrice(completion: @escaping (Double?)-> Void){
        var totalPrice: Double = 0.0
        getItemsInCart { orders, error in
            if error == nil {
                guard let orders = orders, let customerID = self.customerID  else { return }
                for item in orders{
                    if item.userID == customerID {
                        guard let priceStr = item.itemPrice, let price = Double(priceStr) else { return }
                        totalPrice += Double(item.itemQuantity) * price
                    }
                }
                Manager.shared.setTotalPrice(totalPrice: totalPrice)
                completion(totalPrice)
            }else{
                completion(nil)
            }
        }
    }
}


//MARK: - Post Order To Api
extension CartViewModel{
    
    func getCustomer(completion: @escaping (Customer?)-> Void){
        networking.fetchCustomers { customers, error in
            guard let customers = customers, error == nil,let customerID = Manager.shared.getUserID() else {return}

            let checkForCurrentCustomer = customers.filter { selectedCustomer in
                return selectedCustomer.id == customerID
            }
            if checkForCurrentCustomer.count != 0{
                print(checkForCurrentCustomer.count)
                completion(checkForCurrentCustomer[0])
            }else{
                completion(nil)
            }
        }
    }

    
    func postOrder(cartArray:[OrdersInCart]){
        if cartArray.count == 0 {
            self.showEmptyCartAlert()
        }
        else{
        for item in cartArray {
            orderProduct.append(OrderItem(variant_id: Int(item.itemID), quantity: Int(item.itemQuantity), name: item.itemName, price: item.itemPrice,title:item.itemName))
        }
        self.calcTotalPrice { total in
            guard let total = total else {
                return
            }
            self.totalOrder.current_total_price = String(total)
        }
        self.getCustomer { customer in
            guard let customer = customer else {
                return
            }
            let order = Order(customer: customer, line_items: self.orderProduct, current_total_price: self.totalOrder.current_total_price)
            let postOrderOnAPI = OrderToAPI(order: order)
            self.networking.SubmitOrder(order: postOrderOnAPI) { data, urlResponse, error in
                if error == nil {
                    print("Post order success")
                    if let data = data{
                                    let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Any>
                                    let returnedOrder = json["order"] as? Dictionary<String,Any>
                                    let returnedCustomer = returnedOrder?["customer"] as? Dictionary<String,Any>
                                    let id = returnedCustomer?["id"] as? Int ?? 0
                        print(json)
                        print("----------")
                        print(id)

                        for i in cartArray {
                            context.delete(i)
                        }
                        try! context.save()

                                }
                }else{
                    print(error?.localizedDescription)
                }
            }
        }
    }
    }


}
