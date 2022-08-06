//
//  ApiServices.swift
//  BasicStructure
//
//  Created by Noshy on 05/07/2022.
//

import Foundation

protocol ApiService {
    func fetchbranchs(endPoint : String , Completion : @escaping (([SmartCollection]? , Error?) -> Void))
    func fetchProduct(endPoint : String , Completion : @escaping (([Product]? , Error?) -> Void))
    func fetchSingleProduct(endPoint: String, Completion: @escaping ((Product?, Error?) -> Void))
    func fetchCustomers(Completion : @escaping (([Customer]? , Error?) -> Void))
    func register(endPoint: String,newCustomer:NewCustomer, completion:@escaping (Data?, URLResponse? , Error?)->())
    func createAddress(customerId: Int, address: Address, completion: @escaping(Data?, URLResponse?, Error?)->())
}
