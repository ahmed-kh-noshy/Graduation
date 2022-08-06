//
//  PaymentViewController.swift
//  BasicStructure
//
//  Created by Ibrahem's on 14/07/2022.
//

import UIKit
import PassKit
class PaymentViewController: UIViewController {

    @IBOutlet weak var couponTextfield: UITextField!
    @IBOutlet weak var cashOnDeliveryOption: UIButton!
    @IBOutlet weak var applePay: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    @objc func checkCoupon(){
        let checkoutVC = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
     
            if couponTextfield.text == "15%ForThisItem" {
            checkoutVC.coupon = "15%"
            
            
        }
            else if couponTextfield.text == "15%ForThisItem"{
            checkoutVC.coupon = "15%"
            }
     
            else if couponTextfield.text == ""{
            checkoutVC.coupon = "No"
        }
            else if couponTextfield.text != "15%ForThisItem" || couponTextfield.text != "15%ForThisItem" || couponTextfield.text != "15%ForThisItem"{
           showAlertError(title: "Not Valid Copoun", message: "Please Enter A Valid Copoun")
            
        }
            if applePay.isSelected{
            checkoutVC.paymentMethod = "Apple Pay"
        }else{
            checkoutVC.paymentMethod = "Cash On delivery"
        }
            couponTextfield.text = ""
            navigationController?.pushViewController(checkoutVC, animated: false)
        
    }
    
    
    private var PaymentRequest: PKPaymentRequest = {
       let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant."
        request.supportedNetworks = [.masterCard, .visa]
        request.supportedCountries = ["IN","US"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "IN"
        request.currencyCode = "INR"

        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Apple", amount: 100.0)]

        return request
    }()
    
    
    @objc func tapForPay(){

        let controller = PKPaymentAuthorizationViewController(paymentRequest: PaymentRequest)
        if controller != nil {
            controller!.delegate = self
            present(controller!, animated: true)
        }



    }
    
    
    
    @IBAction func cashOnDeliverySelected(_ sender: Any) {
    setOptionSelection(_isApplePaySelected: false)
    }
    
    @IBAction func continueToCheckout(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.couponTextfield.hasText {
                
                self.perform(#selector(self.checkCoupon), with: nil, afterDelay: 1)
                self.couponTextfield.backgroundColor = .systemCyan
        } else {
            self.perform(#selector(self.checkCoupon), with: nil, afterDelay: 1)
        }
            
        }
    }
    @IBAction func applePayButtonPressed(_ sender: UIButton) {
        tapForPay()
        setOptionSelection(_isApplePaySelected: true)
    }
    func setOptionSelection(_isApplePaySelected :Bool){
        if _isApplePaySelected{
            
            self.applePay.isSelected = true
            self.cashOnDeliveryOption.isSelected = false
        }else{
            self.applePay.isSelected = false
            self.cashOnDeliveryOption.isSelected = true
        }
    }
        
}
    extension PaymentViewController: PKPaymentAuthorizationViewControllerDelegate {
        func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
            controller.dismiss(animated: true, completion: nil)
        }
        func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
            completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        }
        
    }
