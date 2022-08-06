//
//  Product.swift
//  BasicStructure
//
//  Created by Noshy on 10/07/2022.
//

import Foundation


// MARK: - Products
struct Products : Codable {
    let products: [Product]
}

// MARK: - Product
struct Product : Codable {
    let id: Int
    let title: String
    let handle: String
    let variants: [Variant]
    let images: [Image]
    let image: Image
    let bodyHTML: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case handle
        case variants, images, image
        case bodyHTML = "body_html"
    }
}



// MARK: - Variant
struct Variant: Codable {
    let id, productID: Int
    let title, price :String

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case title, price
   
    }
}

