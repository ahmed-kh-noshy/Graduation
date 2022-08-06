//
//  AddAddressViewController.swift
//  BasicStructure
//
//  Created by Ibrahem's on 13/07/2022.
//

import UIKit

class AddAddressViewController: UIViewController {

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
  
    let networking = NetworkManger()
    var address = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Enter Shipping Address"
 
    }
    

    @IBAction func saveNewAddress(_ sender: UIButton) {
        
        checkData()
        print("HELP\(Manager.shared.getUserName())........\(Manager.shared.getUserID())")
        if address1TextField.text != "" && cityTextField.text != "" && countryTextField.text != "" && phoneTextField.text != ""
        {
            guard let customerID = Manager.shared.getUserID(), let name = Manager.shared.getUserName(),
                  let address = address1TextField.text, !address.isEmpty,
                  let country = countryTextField.text, !country.isEmpty,
                  let city = cityTextField.text, !city.isEmpty,
                  let phone = phoneTextField.text, !phone.isEmpty, phone.count == 11 else {
                showAlertError(title: "Missing Data", message: "Please fill your info")
                return
            }
            
            let add = Address(address1: address, city: city, province: "", phone: phone, zip: "", last_name: "", first_name: name, country: "Egypt", id: nil)
            
            networking.createAddress(customerId: customerID, address: add) { data , res, error in
                if error == nil{
                    print("success to create address")
                    Manager.shared.setFoundAdress(isFoundAddress: true)
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    print("falied to create address")
                }
            }
        }
        
        
        print("Added")
    }
    
    func checkData() {
        let titleMessage = "Missing Data"
        if countryTextField.text == "" {
            showAlertError(title: titleMessage, message: "Please enter your country name")
        }
            
        if cityTextField.text == "" {
            showAlertError(title: titleMessage, message: "Please enter your city name")
        }
            
        if address1TextField.text == "" {
            showAlertError(title: titleMessage, message: "Please enter your address")
        }
            
        if phoneTextField.text == "" {
            showAlertError(title: titleMessage, message: "Please enter you phone number")
                
        } else {
            let check: Bool = validate(value: phoneTextField.text!)
            if check == false {
                self.showAlertError(title: "invalid data!", message: "please enter you phone number in correct format")
            }
        }
    }
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{11}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: value)
        print("RESULT \(result)")
        return result
    }
}
extension UIViewController{
    func showAlertError(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
