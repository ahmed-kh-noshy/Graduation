//
//  ProductDetailsViewModel.swift
//  BasicStructure
//
//  Created by n0shy on 18/07/2022.
//

import Foundation

class ProductDetailsViewModel{
    var end : String
    
    
    var productArray: Product? {
        didSet {
            bindingData(productArray,nil)
        }
    }
    var error: Error? {
        didSet {
            bindingData(nil, error)
        }
    }
    let apiService : ApiService  // create api service object
    var bindingData: ((Product?,Error?) -> Void) = {_, _ in }
    
    init(apiService: ApiService = NetworkManger() , endpoint : String) {
        self.apiService = apiService
        self.end = endpoint
    }
    
    
    
    func fetchData() {
        apiService.fetchSingleProduct(endPoint: end) { branchs, error in
            if let branchs = branchs {
                self.productArray = branchs
            }
            
            if let error = error {
                self.error = error
            }
        }
    }
}
