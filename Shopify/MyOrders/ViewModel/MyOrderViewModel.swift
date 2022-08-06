//
//  MyOrderViewModel.swift
//  BasicStructure
//
//  Created by Noshy on 16/07/2022.
//

import Foundation

class MyOrdersViewModel{
    
    let network = NetworkManger()
    
    var bindSuccessToView: (()->()) = {}
    var bindeLinesitemToView : (()->()) = {}
    var bindFailedToView : (()->()) = {}
    
    var orders: [Order]! {
        didSet{
            self.bindSuccessToView()
        }
    }
    
    
    var showError: String!{
        didSet{
            self.bindFailedToView()
        }
    }
    
    init(){
        self.fetchAllOrders()
    }
    
    func fetchAllOrders(){
        network.getAllOrders { orderFromAPI, error in
            if let orderFromAPI = orderFromAPI {
                self.orders = orderFromAPI
            }
            else{
                self.showError = error?.localizedDescription
            }
        }
        }
    }
    
    
    
    
    
    
    
