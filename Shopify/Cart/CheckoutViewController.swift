//
//  CheckoutViewController.swift
//  BasicStructure
//
//  Created by Ibrahem's on 13/07/2022.
//
//
import UIKit

class CheckoutViewController: UIViewController {

    @IBOutlet weak var enterCouponTextView: UITextView!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var expressButton: UIButton!
    @IBOutlet weak var standardButton: UIButton!
    let db = DBManager.sharedInstance
    var totalValue : String = ""
    var originalTotalValue: Double = 0.0
    var copoun : String?
    var paymentMethod : String?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.totalValueLabel.text = "\(totalValue)"
//        let valueInDouble = Double(totalValue.substring(with: 1..<totalValue.count))
    //    originalTotalValue = valueInDouble!


        enterCouponTextView.layer.borderWidth = 2
        enterCouponTextView.layer.borderColor = UIColor.black.cgColor

    }

    @IBAction func validateCouponButton(_ sender: UIButton) {
        //["SUMMERDiscount10%","20%Discount","30%ForThisItem"]


        let valueInDouble = Double(totalValue.substring(with: 1..<totalValue.count))
        self.totalValueLabel.text = "$\(valueInDouble! + 15)"

        let coupon = db.setUpCoupons()

        if  !(coupon.filter({$0 == enterCouponTextView.text}).first != nil) {

            let alert = UIAlertController(title: "Invalid Coupoun", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
           print("Accepted")

            enterCouponTextView.backgroundColor = .green
            totalValueLabel.text = "\(valueInDouble! / 10.0)"
        }
//        standardButton.isEnabled = true
//        expressButton.isEnabled = false

//      var animalDict: [String: Int] = ["cow": 0,"pig": 1]
//        var animalSelection: Int = animalDict["cow"]!
//
//        switch animalSelection {
//        case 0:
//            println("The Cow Wins!")
//        case 1:
//            println("The Pig Wins!")
//        default:
//            println("Keep Trying")
//        }

    }


    @IBAction func standardSelection(_ sender: Any) {
        standardButton.isEnabled = false
        expressButton.isEnabled = true

        self.totalValueLabel.text = "$\(originalTotalValue)"
    }
    func filedAlert(){

        if enterCouponTextView.text.isEmpty {
            Utils.showAlertMessage(vc: self, title: "", message: "No Coupon Entered")
            return
        }
    }
    @IBAction func placeOrderDidSelect(_ sender: Any) {
//
//        let alertController = UIAlertController(title: "Confirm Order", message: "Please confirm that you want to make a payment of \(totalValueLabel.text!)!", preferredStyle: .alert)
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        let confirm = UIAlertAction(title: "Confirm", style: .default) { (action) in
//            let sucessActionSheet = UIAlertController(title: "Thank you", message: "Your payment of \(self.totalValueLabel.text!) was processed successfully! Please check your email for your order receipt email and shipping information.", preferredStyle: .actionSheet)
//            let continueShoppingAction = UIAlertAction(title: "Let's Shop More!", style: .default, handler: { (action) in
//                self.navigationController?.popToRootViewController(animated: true)
//            })
//
//            sucessActionSheet.addAction(continueShoppingAction)
//            self.present(sucessActionSheet, animated: true, completion: nil)
//        }
//        alertController.addAction(cancel)
//        alertController.addAction(confirm)
//
//        self.present(alertController, animated: true, completion: nil)
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
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}
