////
////  PaymentOptionsViewController.swift
////  BasicStructure
////
////  Created by Ibrahem's on 08/07/2022.
////
//
//import UIKit
//import PassKit
//
//class PaymentOptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
//    @IBOutlet weak var paymentOptionsTableView: UITableView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        paymentOptionsTableView.delegate = self
//        paymentOptionsTableView.dataSource = self
//        paymentOptionsTableView.register(UINib(nibName: "PaymentOptionsTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentOptionsTableViewCell")
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = paymentOptionsTableView.dequeueReusableCell(withIdentifier: "PaymentOptionsTableViewCell", for: indexPath) as! PaymentOptionsTableViewCell
//        
//        if indexPath.section == 0 {
//            cell.paymentMethod.text = "Apple Pay"
//            
//        }
//        else {
//            cell.paymentMethod.text = "Cash ON Delivery(COD)"
//        }
//        
//     
//             
//        return cell
//    }
//    
//    
//    
//    private var PaymentRequest: PKPaymentRequest = {
//       let request = PKPaymentRequest()
//        request.merchantIdentifier = "merchant."
//        request.supportedNetworks = [.quicPay, .masterCard, .visa]
//        request.supportedCountries = ["IN","US"]
//        request.merchantCapabilities = .capability3DS
//        request.countryCode = "IN"
//        request.currencyCode = "INR"
//        
//        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Apple", amount: 100.0)]
//        
//        return request
//    }()
//    
//    
//    @objc func tapForPay(){
//        
//        let controller = PKPaymentAuthorizationViewController(paymentRequest: PaymentRequest)
//        if controller != nil {
//            controller!.delegate = self
//            present(controller!, animated: true)
//        }
//       
//      
//        
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedCell = tableView.cellForRow(at: indexPath)
//        tableView.deselectRow(at: indexPath, animated: true)
//        switch (indexPath.section)
//               {
//               case 0:
//            tapForPay()
//        
//               case 1:
//            tapForPay()
//    
//               default:
//                        print("ERROR")
//               }
//       
//    }
//    
//    @IBAction func ProceedToplaceOrder(_ sender: UIButton) {
//        let placeOrderScreen = self.storyboard?.instantiateViewController(identifier: "PlaceOrderViewController") as! PlaceOrderViewController
//        
//        self.present(placeOrderScreen, animated: true, completion: nil)
//    }
//    
//}
//
//extension PaymentOptionsViewController: PKPaymentAuthorizationViewControllerDelegate {
//    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
//        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
//    }
//    
//}
