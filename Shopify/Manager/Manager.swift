//
//  TestModel.swift
//  BasicStructure
//
//  Created by Noshy on 05/07/2022.
//


//import Foundation
//
//
////var userID = user.object(forKey: "id")
//class Manager{
//    static let shared = Manager()
//
////MARK: - Managing Authentication
//
//    func checkUserIsLogged(completion: @escaping (Bool) -> Void){
//        if getUserStatus() {
//            completion(true)
//        }else{
//            completion(false)
//        }
//    }
////MARK: - Managing Authentication (Register)
//
//    func setUserStatus(userIsLogged: Bool){
//        UserDefaults.standard.set(userIsLogged, forKey: "User_Status")
//    }
//
//    func setUserID(customerID: Int?){
//        UserDefaults.standard.set(customerID, forKey: "User_ID")
//    }
//    func setUserEmail(userEmail: String?){
//        UserDefaults.standard.set(userEmail, forKey: "User_Email")
//    }
//
//    func setUserName(userName: String?){
//        UserDefaults.standard.set(userName, forKey: "User_Name")
//    }
//
//
//    func getUserID()-> Int?{
//        return UserDefaults.standard.integer(forKey: "id")
//    }
//    func getUserName()-> String?{
//        return UserDefaults.standard.string(forKey: "User_Name")
//    }
//    func getUserEmail()-> String?{
//        return UserDefaults.standard.string(forKey: "User_Email")
//    }
//
//    func getUserStatus()-> Bool{
//        return UserDefaults.standard.bool(forKey: "User_Status")
//    }
//
//     //MARK: - Managing Cart
//     func setTotalPrice(totalPrice:Double){
//         UserDefaults.standard.set(totalPrice, forKey: "Total_Price")
//     }
//
//     func getTotalPrice()->Double?{
//         return UserDefaults.standard.double(forKey: "Total_Price")
//     }
//
//
// //MARK: - Managing Addresses
//     func checkFoundAdress()-> Bool{
//         return UserDefaults.standard.bool(forKey: "Address_Found")
//     }
//     func setFoundAdress(isFoundAddress: Bool){
//         UserDefaults.standard.set(isFoundAddress, forKey: "Address_Found")
//     }
//}
import Foundation


//var userID = user.object(forKey: "id")
class Manager{
    static let shared = Manager()
   
    
    func setUserStatus(userIsLogged: Bool){
        UserDefaults.standard.set(userIsLogged, forKey: "User_Status")
    }
    
    func getUserStatus()-> Bool{
        return UserDefaults.standard.bool(forKey: "User_Status")
    }
    
    func setUserID(customerID: Int?){
        UserDefaults.standard.set(customerID, forKey: "id")
    }
    
    func getUserID()-> Int?{
        return UserDefaults.standard.integer(forKey: "id")
    }
    
    func setUserName(userName: String?){
        UserDefaults.standard.set(userName, forKey: "User_Name")
    }
    
    func getUserName()-> String?{
        return UserDefaults.standard.string(forKey: "User_Name")
    }
    
    func setUserEmail(userEmail: String?){
        UserDefaults.standard.set(userEmail, forKey: "User_Email")
    }
    
    func getUserEmail()-> String?{
        return UserDefaults.standard.string(forKey: "User_Email")
    }
    
    func setTotalPrice(totalPrice:Double){
        UserDefaults.standard.set(totalPrice, forKey: "Total_Price")
    }
    
    func getTotalPrice()->Double?{
        return UserDefaults.standard.double(forKey: "Total_Price")
    }
    
    func setFoundAdress(isFoundAddress: Bool){
        UserDefaults.standard.set(isFoundAddress, forKey: "Address_Found")
    }
    
    func checkFoundAddress()-> Bool{
        return UserDefaults.standard.bool(forKey: "Address_Found")
    }
    func checkUserIsLogged(completion: @escaping (Bool) -> Void){
        if getUserStatus() {
            completion(true)
        }else{
            completion(false)
        }
    }
}
