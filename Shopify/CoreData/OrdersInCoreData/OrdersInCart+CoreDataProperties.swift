//
//  OrdersInCart+CoreDataProperties.swift
//  BasicStructure
//
//  Created by Ibrahem's on 15/07/2022.
//
//

import Foundation
import CoreData


extension OrdersInCart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrdersInCart> {
        return NSFetchRequest<OrdersInCart>(entityName: "OrdersInCart")
    }

    @NSManaged public var itemID: Int64
    @NSManaged public var itemName: String?
    @NSManaged public var itemImage: String?
    @NSManaged public var itemQuantity: Int64
    @NSManaged public var userID: Int64
    @NSManaged public var itemPrice: String?

}

extension OrdersInCart : Identifiable {

}
