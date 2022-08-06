//
//  CheckoutViewModel.swift
//  BasicStructure
//
//  Created by Ibrahem's on 16/07/2022.
//

import Foundation
class CheckoutViewModel{
    
    let db = DBManager.sharedInstance
    
    
    func getSelectedAddress(completion: @escaping (AddressEntity?, Error?)-> Void){
        db.getAddress { selectedAddress, error in
            if let selectedAddress = selectedAddress {
                completion(selectedAddress, nil)
            }else{
                completion(nil, error)
            }
        }
    }
}
