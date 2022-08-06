//
//  HomeViewModel.swift
//  BasicStructure
//
//  Created by Noshy on 05/07/2022.
//

import Foundation
class HomeViewModel {
    
    var end : String
    
    
    var usersArray: [SmartCollection]? {
        didSet {
            bindingData(usersArray,nil)
        }
    }
    var error: Error? {
        didSet {
            bindingData(nil, error)
        }
    }
    let apiService : ApiService  // create api service object
    var bindingData: (([SmartCollection]?,Error?) -> Void) = {_, _ in }
    init(apiService: ApiService = NetworkManger() , endpoint : String) {
        self.apiService = apiService
        self.end = endpoint
    }
    
    
    
    func fetchData() {
        apiService.fetchbranchs(endPoint: end) { branchs, error in
            if let branchs = branchs {
                self.usersArray = branchs
            }
            
            if let error = error {
                self.error = error
            }
            
        }
        
        
        
        
    
    }
    
    
    
}
