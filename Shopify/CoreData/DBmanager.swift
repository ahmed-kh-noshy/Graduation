//
//  DBManager.swift
//  BasicStructure
//
//  Created by Tarek on 11/07/2022.
//

import Foundation
import CoreData
import UIKit

protocol DeletionDelegate{
    func deleteProductAtIndexPath(indexPath: IndexPath)
}

class DBManager{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var managedContext = appDelegate.persistentContainer.viewContext
    static let sharedInstance = DBManager()
    private init(){
        print("Data Base")
    }
}
extension DBManager{


    func addProduct(productID: Int64,productName: String, productImage: String, productDescription: String, productPrice: String, appDelegate: AppDelegate){
        let managedContext = appDelegate.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "Favourite", in: managedContext){
            let product = NSManagedObject(entity: entity, insertInto: managedContext)
            product.setValue(productName, forKey: "productName")
            product.setValue(productImage,forKey: "productImage")
            product.setValue(productDescription,forKey: "productDescription")
            product.setValue(productPrice,forKey: "productPrice")
            product.setValue(productID, forKey: "productID")
            print("Set Data")
            do {
                try managedContext.save()
                print("Save Data Base")
            }catch let error as NSError {
                print("Error in saving")
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchData(appDelegate: AppDelegate) -> [Favourite]{

        var fetchedList : [Favourite] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favourite")


        do{
            fetchedList = try managedContext.fetch(fetchRequest) as! [Favourite]
        }catch let error as NSError {
            print("Error in saving")
            print(error.localizedDescription)
        }
        return fetchedList
    }

    func delete(product:Favourite, indexPath: IndexPath, appDelegate: AppDelegate, delegate: DeletionDelegate){

        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(product)
        do{
            try managedContext.save()
            delegate.deleteProductAtIndexPath(indexPath: indexPath)
            print("Cell Is Deleted")
        }catch let error as NSError{
            print("Error in saving")
            print(error.localizedDescription)
        }
        
    }
    func fetchFavouriteProduct(fetchedData: inout [NSManagedObject])->[NSManagedObject]{

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favourite")
        let managedContext = appDelegate.persistentContainer.viewContext
        do{
            fetchedData = try managedContext.fetch(fetchRequest)
        }catch let error as NSError{
            print(error)
        }
        
        return fetchedData
        
    }
    func deleteFavouriteProduct(deletedData: NSManagedObject){
        managedContext.delete(deletedData)
        
        do{
            try managedContext.save()
            
        }catch let error as NSError
        {
            print(error)
        }
    }
    func deleteFavouriteProduct(deletedData: Product){
        var tempProduct : Favourite?

        var favProduct : [NSManagedObject] = []
        favProduct = fetchFavouriteProduct(fetchedData: &favProduct)



        for l in favProduct{
            if l.value(forKey: "productName") as? String == deletedData.handle{
                tempProduct = l as? Favourite
            }

        }
        guard let temp = tempProduct else{
            return
        }

        deleteFavouriteProduct(deletedData: temp)
    }
}



extension DBManager{
    func saveToCoreData(completion: @escaping (Bool)-> Void){
        do{
            try context.save()
            completion(true)
        }catch{
            print("Error in saveProductToWishList", error.localizedDescription)
            completion(false)
        }
    }
}
// MARK: - Coupons

extension DBManager {
    func setUpCoupons()->[String] {
        let couponArray = ["SUMMERDiscount10%","20%Discount","30%ForThisItem"]
        
        return couponArray
    }
}
// MARK: - selectedCustomer
extension DBManager{
    func getCartProductForSelectedCustomer(customerID: Int, completion: @escaping ([OrdersInCart]?, Error?)-> Void){
        do{
            let productCart = try context.fetch(OrdersInCart.fetchRequest())
            var selectedCart: [OrdersInCart] = []
            for selectedCustomer in productCart{
                if selectedCustomer.userID == customerID{
                    selectedCart.append(selectedCustomer)
                }
            }
            completion(selectedCart, nil)
       }catch{
           completion(nil, error)
            print("Error in getAllCartProduct function: ", error.localizedDescription)
        }
    }
}
// MARK: - Address
extension DBManager{
    func getAddress(completion: @escaping (AddressEntity?, Error?)-> Void){
        do{
            let addressModel = try context.fetch(AddressEntity.fetchRequest())
            print("fetching data.....")
            completion(addressModel[0], nil)
        }catch{
            completion(nil, error)
            print("Error in getAddress function: ", error.localizedDescription)
        }
    }
}
