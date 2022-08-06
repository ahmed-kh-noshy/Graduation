//
//  AddressEntity+CoreDataProperties.swift
//  BasicStructure
//
//  Created by Ibrahem's on 15/07/2022.
//
//

import Foundation
import CoreData


extension AddressEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AddressEntity> {
        return NSFetchRequest<AddressEntity>(entityName: "AddressEntity")
    }

    @NSManaged public var addID: Int64
    @NSManaged public var firstAddress: String?
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var customerID: Int64
    @NSManaged public var customerName: String?
    @NSManaged public var phoneNumber: String?

}

extension AddressEntity : Identifiable {

}
