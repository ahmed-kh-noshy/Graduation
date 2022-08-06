//
//  AddAddressViewModel.swift
//  BasicStructure
//
//  Created by Ibrahem's on 15/07/2022.
//

import Foundation

class AddressViewModel{
    
    let db = DBManager.sharedInstance
    let networking = NetworkManger()
    var bindSuccessToView: (()->()) = {}
    var address: [Address]! {
        didSet{
            self.bindSuccessToView()
        }
    }
    
    var bindFailedToView: (()->()) = {}
    var error: Error!{
        didSet{
            self.bindFailedToView()
        }
    }
    
    init(){
        self.getAllAddressForCustomer()
    }
    
    func getAllAddressForCustomer(){
        networking.getAllAddresses { arrayOfAddresses, error in
            guard let arrayOfAddresses = arrayOfAddresses, error == nil else {
                self.error = error
                return
            }
            self.address = arrayOfAddresses
        }
    }
    
    func saveSelectedAddress(){
        db.saveToCoreData { saveSuccess in
            if saveSuccess{
                print("success to save address")
            }else{
                print("failed to save address")
            }
        }
    }
}
