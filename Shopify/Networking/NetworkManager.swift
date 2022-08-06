//
//  NetworkManager.swift
//  BasicStructure
//
//  Created by Noshy on 04/07/2022.
//

import Foundation


class NetworkManger : ApiService {
    
    func fetchbranchs(endPoint: String, Completion: @escaping (([SmartCollection]?, Error?) -> Void)) {
        var arrayOfBranchs = [SmartCollection]()
        
        if let url = URL(string: UrlService(endPoint: endPoint).url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let insideData = data {
                    print(insideData)
                    let decodeArray : SmartCollectionsModel? = convertFromJson(data: insideData)
                    arrayOfBranchs = decodeArray!.smart_collections
                    print("decode array \(arrayOfBranchs)")
                    Completion(arrayOfBranchs , nil)
                }
                if let errorInside = error {
                    Completion(nil , errorInside)
                }
            }.resume()
        }
    }
    
    
    
    func fetchProduct(endPoint: String, Completion: @escaping (([Product]?, Error?) -> Void)) {
        var arrayOfBranchs = [Product]()

        if let url = URL(string: UrlService(endPoint: endPoint).url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let insideData = data {
                    print(insideData)
                    let decodeArray : Products? = convertFromJson(data: insideData)
                    arrayOfBranchs = decodeArray!.products
                    print("decode array \(arrayOfBranchs)")
                    Completion(arrayOfBranchs , nil)
                }
                if let errorInside = error {
                    Completion(nil , errorInside)
                }
            }.resume()
        }
    }
    func fetchSingleProduct(endPoint: String, Completion: @escaping ((Product?, Error?) -> Void)) {
        var product : Product?

        if let url = URL(string: UrlService(endPoint: endPoint).url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let insideData = data {
                    print(insideData)
                    let decodeArray : Product? = convertFromJson(data: insideData)
                    product = decodeArray
                
                    Completion(product , nil)
                }
                if let errorInside = error {
                    Completion(nil , errorInside)
                }
            }.resume()
        }
    }
    
    func fetchCustomers(Completion: @escaping (([Customer]?, Error?) -> Void)) {
        var arrayOfCustomers = [Customer]()

        if let url = URL(string: UrlService(endPoint: "customers.json").url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let insideData = data {
                    print(insideData)
                    let decodeArray : Customers? = convertFromJson(data: insideData)
                    arrayOfCustomers = decodeArray!.customers
                    print("decode array \(arrayOfCustomers)")
                    Completion(arrayOfCustomers , nil)
                }
                if let errorInside = error {
                    Completion(nil , errorInside)
                }
            }.resume()
        }
    }
    
    // POST Function
    func register(endPoint: String,newCustomer:NewCustomer, completion:@escaping (Data?, URLResponse? , Error?)->()){
        if let url = URL(string: UrlService(endPoint: endPoint).url) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let session = URLSession.shared
            request.httpShouldHandleCookies = false
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: newCustomer.asDictionary(), options: .prettyPrinted)
                print(try! newCustomer.asDictionary())
            } catch let error {
                print(error.localizedDescription)
            }
            
            //HTTP Headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            session.dataTask(with: request) { (data, response, error) in
                completion(data, response, error)
            }.resume()
        }
    }
    
    func SubmitOrder(order:OrderToAPI,completion: @escaping (Data?,URLResponse?,Error?)->Void){
        let urlStr = UrlService(endPoint: "orders.json" ).url
        guard let url = URL(string: urlStr) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: order.asDictionary(), options: .prettyPrinted)
            print(try! order.asDictionary())
        }catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        session.dataTask(with: request) { (data,response,error) in
            completion(data, response, error)
        }.resume()
    }
    
    func getAllOrders(completion: @escaping ([Order]?, Error?)-> Void){
        var arrayOfOrder = [Order]()
        guard let customerID = Manager.shared.getUserID() else {return}
        if let url = URL(string: UrlService(endPoint: "customers/\(customerID)/orders.json").url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let insideData = data {
                    print(insideData)
                    let decodeArray : OrdersFromAPI? = convertFromJson(data: insideData)
                    arrayOfOrder = decodeArray!.orders
                    print("decode array \(arrayOfOrder)")
                    completion(arrayOfOrder , nil)
                }
                if let errorInside = error {
                    completion(nil , errorInside)
                }
            }.resume()
        }

      
    }
//    func getAllOrders(completion: @escaping ([Order]?,Error?)->Void){
//        var arrayOfOrder = [Order]()
//        let userID = Helper.shared.getUserID()
//        guard let url = URLs.shared.getOrdersUser(customerId: userID!) else {return}
//      e in
//            switch response.result {
//            case .failure(let error):
//                print(error)
//            case .success(_):
//                guard let data = response.data else {return}
//                do {
//                    let json = try JSONDecoder().decode(OrdersFromAPI.self, from: data)
//                    completion(json.orders,nil)
//                    print("Success in retrieving Orders data")
//                }
//                catch {
//                    print("error when getting Orders data")
//                }
//
//            }
//        }
//    }

    //MARK: - Addresses
    func createAddress(customerId: Int, address: Address, completion: @escaping(Data?, URLResponse?, Error?)->()){
        let customer = CustomerAddress(addresses: [address])
        let putObject = PutAddress(customer: customer)
        let urlStr = UrlService(endPoint: "customers/\(customerId).json" ).url
        print("HELP\(customerId)")
        guard let url = URL(string: urlStr) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: putObject.asDictionary(), options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    
    func setDefaultAddress(customerId: Int, addressId: Int, address: Address, completion: @escaping(Data?, URLResponse?, Error?)->()){

        let customer = CustomerAddress(addresses: [address])
        let putObject = PutAddress(customer: customer)
        let urlStr = UrlService(endPoint: "customers/\(customerId).json" ).url
        guard let url = URL(string: urlStr) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: putObject.asDictionary(), options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    func getAllAddresses(completion: @escaping ([Address]?, Error?)-> Void){
        var arrayOfAddresses = [Address]()
        guard let customerID = Manager.shared.getUserID() else {return}
        if let url = URL(string: UrlService(endPoint: "customers/\(customerID)/addresses.json").url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let insideData = data {
                    print(insideData)
                    let decodeArray : CustomerAddress? = convertFromJson(data: insideData)
                    arrayOfAddresses = decodeArray!.addresses ?? []
                    print("decode array \(arrayOfAddresses)")
                    completion(arrayOfAddresses , nil)
                }
                if let errorInside = error {
                    completion(nil , errorInside)
                }
            }.resume()
        }

      
    }
   

}
