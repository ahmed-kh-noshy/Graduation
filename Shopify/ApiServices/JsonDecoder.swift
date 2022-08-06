//
//  JsonDecoder.swift
//  BasicStructure
//
//  Created by Ibrahem's on 05/07/2022.
//

import Foundation
func convertFromJson<T: Codable>(data : Data) -> T? {
    print("decode data")
    let jsonDecoder = JSONDecoder()
    let decodeArray = try? jsonDecoder.decode(T.self, from: data)
    return decodeArray
}

extension Encodable{
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
          throw NSError()
        }
        return dictionary
      }
}

