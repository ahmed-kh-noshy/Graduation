//
//  Model.swift
//  BasicStructure
//
//  Created by Noshy on 04/07/2022.
//


import Foundation
import UIKit

struct SmartCollectionsModel: Codable {
    let smart_collections: [SmartCollection]
}
struct SmartCollection: Codable {
    let id: Int
    let handle, title: String?
//    let image : String?
    let image:Image
}
struct Image: Codable {
    let createdAt: Date?
    //let alt: JSONNull?
    let width, height: Int
    let src: String


}
enum CodingKeys: String, CodingKey {
    case createdAt = "created_at"
    case alt, width, height, src
}
