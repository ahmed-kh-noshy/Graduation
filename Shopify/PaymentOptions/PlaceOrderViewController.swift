//
//  PlaceOrderViewController.swift
//  BasicStructure
//
//  Created by Ibrahem's on 08/07/2022.
//

import UIKit

class PlaceOrderViewController: UIViewController {

    @IBOutlet weak var enterCouponTextView: UITextView!
    let db = DBManager.sharedInstance
    
    var isClicked = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        enterCouponTextView.layer.borderWidth = 2
        enterCouponTextView.layer.borderColor = UIColor.black.cgColor
    }
    

   
    
    
    
    
     @IBAction func placeOrderButtonPressed(_ sender: UIButton) {
         let alertController = UIAlertController(
                title: "Done", message: "Congratulations, Your order has Been placed Successfully", preferredStyle: .alert)
         let defaultAction = UIAlertAction(
                title: "OK", style: .default, handler: nil)
         //you can add custom actions as well
         alertController.addAction(defaultAction)

         present(alertController, animated: true, completion: nil)
         
         let backToHome = self.storyboard?.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
         
         self.present(backToHome, animated: true, completion: nil)
         
     }
    func filedAlert(){
      
        if enterCouponTextView.text.isEmpty {
            Utils.showAlertMessage(vc: self, title: "", message: "No Coupon Entered")
            return
        }
    }
    @IBAction func validateButton(_ sender: UIButton) {
        //["SUMMERDiscount10%","20%Discount","30%ForThisItem"]
        
        let coupon = db.setUpCoupons()
        if  !(coupon.filter({$0 == enterCouponTextView.text}).first != nil) {
           
            let alert = UIAlertController(title: "Invalid Coupoun", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
           print("Accepted")
            enterCouponTextView.backgroundColor = .green
        }
        
//        let customer = getCustomer()
//
//            if customer.id != 0 {
//                
//                user.set(customer.id, forKey: "id")
//                user.set(customer.email, forKey: "email")
//                user.set(customer.firstName, forKey: "firstName")
//                user.set(customer.addresses, forKey: "addresses")
//                
//                
//                self.navigationController?.popToRootViewController(animated: true)
//            }else{
//                Utils.showAlertMessage(vc: self, title: "Filed to LogIn", message: "Please Check your Email and Password")
//            }
    }
    
}
