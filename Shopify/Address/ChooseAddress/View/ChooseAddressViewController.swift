//
//  ChooseAddressViewController.swift
//  BasicStructure
//
//  Created by Ibrahem's on 08/07/2022.
//

import UIKit

class ChooseAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
   
    
    @IBOutlet weak var continueToPaymentButtonContainer: UIView!
    
    @IBOutlet weak var addAddreesButtonContainer: UIView!
    @IBOutlet weak var editButtonOutlet: UIBarButtonItem!
    
    @IBOutlet weak var chooseAddressTableView: UITableView!
    var isClicked = false
    var index: Address!
    
    var arrayOfAddress: [Address] = []
    let addressViewModel = AddressViewModel()
    let networking = NetworkManger()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAddress()
        
           continueToPaymentButtonContainer.layer.borderWidth = 0.5
           continueToPaymentButtonContainer.layer.cornerRadius = 10
           continueToPaymentButtonContainer.clipsToBounds = true
           addAddreesButtonContainer.layer.borderWidth = 0.5
           addAddreesButtonContainer.layer.cornerRadius = 10
           addAddreesButtonContainer.clipsToBounds = true
           
        self.title = "Choose Address"
        chooseAddressTableView.allowsMultipleSelection = false

        chooseAddressTableView.delegate = self
        chooseAddressTableView.dataSource = self
        chooseAddressTableView.register(UINib(nibName: "ChooseAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "ChooseAddressTableViewCell")
        chooseAddressTableView.reloadData()
        chooseAddressTableView.layer.borderWidth = 0.5
        chooseAddressTableView.layer.cornerRadius = 10
        chooseAddressTableView.clipsToBounds = true
    }
    func setAddress(){
        addressViewModel.bindSuccessToView = {
            self.arrayOfAddress = self.addressViewModel.address
            DispatchQueue.main.async {
                self.chooseAddressTableView.reloadData()
            }
         
        }
        
        addressViewModel.bindFailedToView = {
            print("erro when get address")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfAddress.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chooseAddressTableView.dequeueReusableCell(withIdentifier: "ChooseAddressTableViewCell", for: indexPath) as! ChooseAddressTableViewCell
        let address = self.arrayOfAddress[indexPath.row]
        
        if let firstAddress = address.address1, let city = address.city, let country = address.country, let name = address.first_name{
             cell.firstAddressLabel.text = "\(firstAddress)"
            cell.countryAndCityLabelForAddress.text = "\(city), \(country)"
            cell.customerName.text = "\(name)"
           
  
         }
        return cell
    }
    @objc func editAddressAction(sender: UIButton) {
        print("")
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chooseAddressTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        guard let customrtId = Manager.shared.getUserID(), let id = self.arrayOfAddress[indexPath.row].id else {return}
        
 
        let alert = UIAlertController(title: "Confrim This Address For Shipping",
                                              message: "",
                                              preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(action: UIAlertAction!) in

                self.chooseAddressTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                self.addAddressToOrder(row: indexPath.row)
                        self.goToPayment()

                }))

                alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: {(action: UIAlertAction!) in
                    self.index = self.arrayOfAddress[indexPath.row]
                    self.goToEditAddress()
                    //                    self.chooseAddressTableView.cellForRow(at: indexPath)?.tag = self.index
                   


                }))

                alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: {(action: UIAlertAction!) in

                    //function to execute when button is clicked
                }))

                self.present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            arrayOfAddress.remove(at: indexPath.row)
            chooseAddressTableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        chooseAddressTableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    @IBAction func editAddressesButton(_ sender: UIBarButtonItem) {
        chooseAddressTableView.isEditing = !chooseAddressTableView.isEditing
        if chooseAddressTableView.isEditing {
            self.editButtonOutlet.title = "Done"
           
        }
        else {
            self.editButtonOutlet.title = "Edit"
        }
        
    }
    
    @IBAction func continueToPayment(_ sender: UIButton) {
        
        
        let paymentViewController = storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        self.navigationController?.pushViewController(paymentViewController, animated: true)
     
    }
    
    @IBAction func addNewAddressButton(_ sender: UIButton) {
        
        let newAddressViewController = storyboard?.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        self.navigationController?.pushViewController(newAddressViewController, animated: true)
    }
}

extension ChooseAddressViewController{
    func setAddressDefault(customerId: Int, addressId: Int, row: Int){
        networking.setDefaultAddress(customerId: customerId, addressId: addressId, address: self.arrayOfAddress[row]) { data, res, error in
            if error == nil {
                print("set def success")
               
            }else{
                print("set def falied")
            }
        }
    }
    func addAddressToOrder(row: Int){
        let myAddress = arrayOfAddress[row]
        let selectedAddress = AddressEntity(context: context)
        
        guard let customerId = Manager.shared.getUserID(), let addressID = myAddress.id , let address1 = myAddress.address1, let city = myAddress.city, let country = myAddress.country, let name = myAddress.first_name, let phone = myAddress.phone else {return}
        
        selectedAddress.customerID = Int64(customerId)
        selectedAddress.addID = Int64(addressID)
        selectedAddress.firstAddress = address1
        selectedAddress.city = city
        selectedAddress.country = country
        selectedAddress.customerName = name
        selectedAddress.phoneNumber = phone
        
        self.addressViewModel.saveSelectedAddress()
    }
    
    func goToPayment(){
//        let paymentVC = UIStoryboard(name: "PaymentViewController", bundle: nil).instantiateViewController(withIdentifier: "PaymentViewController")
//        self.navigationController?.pushViewController(paymentVC, animated: true)
        
        let paymentVC = storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        self.navigationController?.pushViewController(paymentVC, animated: true)
    }
    func goToEditAddress(){
        
        
        
        let viewAddressVC = storyboard?.instantiateViewController(withIdentifier: "ViewAddressViewController") as! ViewAddressViewController
        
        viewAddressVC.address = index.address1!
        viewAddressVC.city = index.city!
        viewAddressVC.country = index.country!
        viewAddressVC.phoneNumber = index.phone!
        viewAddressVC.customerName = index.first_name!
        self.navigationController?.pushViewController(viewAddressVC, animated: true)
        
    }
}
extension UIViewController{
    func showConfirmAlert(title:String, message:String, complition:@escaping (Bool)->Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmBtn = UIAlertAction(title: "Confirm", style: .destructive) { _ in
            complition(true)
        }
        alert.addAction(cancelBtn)
        alert.addAction(confirmBtn)
        self.present(alert, animated: true, completion: nil)
    }
}
//extension ChooseAddressViewController: ChooseAddressTableViewCellDelegate{
//    func didTapEditButton(with title: String) {
//        let viewAddressVC = storyboard?.instantiateViewController(withIdentifier: "ViewAddressViewController") as! ViewAddressViewController
//        self.navigationController?.pushViewController(viewAddressVC, animated: true)
//
//
//             viewAddressVC.address = title
//
//    }
//



