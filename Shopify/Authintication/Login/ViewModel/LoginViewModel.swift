//
//  LoginViewModel.swift
//  BasicStructure
//
//  Created by Tarek on 14/07/2022.
//

import Foundation

class LoginViewModel {
    
    var end : String
    
    var customerArray: [Customer]? {
        didSet {
            bindingData(customerArray,nil)
        }
    }
    
    var error: Error? {
        didSet {
            bindingData(nil, error)
        }
    }
    
    let apiService : ApiService  // create api service object
    var bindingData: (([Customer]?,Error?) -> Void) = {_, _ in }
    init(apiService: ApiService = NetworkManger() , endpoint : String) {
        self.apiService = apiService
        self.end = endpoint
    }
    
    func fetchData() {
        apiService.fetchCustomers() { customer, error in
            if let customer = customer {
                self.customerArray = customer
            }
            
            if let error = error {
                self.error = error
            }
        }
    }
}
