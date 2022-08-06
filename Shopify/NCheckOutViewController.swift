//
//  NCheckOutViewController.swift
//  BasicStructure
//
//  Created by Ibrahem's on 14/07/2022.
//

import UIKit

class CheckoutViewController: UIViewController {

    @IBOutlet weak var mainStackOutlet: UIStackView!
    
    @IBOutlet weak var checkoutTableView: UITableView!
  
    @IBOutlet weak var checkoutContainerSecond: UIView!
    @IBOutlet weak var checkoutContainerFirst: UIView!
    @IBOutlet weak var deliveryTimeLAbel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var copounLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    var coupon : String?
    var paymentMethod : String?
    var placedOrders = [OrdersInCart]()
    var orderViewModel = CartViewModel()
    var result = Double()
    let checkoutViewModel = CheckoutViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCartItems()
        checkoutTableView.dataSource = self
        checkoutTableView.delegate = self
        checkoutTableView.register(OrdersTableViewCell.nib(), forCellReuseIdentifier: OrdersTableViewCell.identifier)
  
        setTotalPriceData()
        
        mainStackOutlet.layer.borderWidth = 0.5
        mainStackOutlet.layer.cornerRadius = 10
        mainStackOutlet.clipsToBounds = true


    }
    
    func setCartItems(){
        orderViewModel.getSelectedProducts { orders, error in
            guard let orders = orders else {return}
            self.placedOrders = orders
            self.checkoutTableView.reloadData()
        }
    }
    
    @IBAction func toCart(_ sender: Any) {
        let cartVC = UIStoryboard(name: "orders", bundle: nil).instantiateViewController(withIdentifier: "OrdersVC")
        navigationController?.pushViewController(cartVC, animated: false)
    }
    
    @IBAction func checkoutBtn(_ sender: Any) {
        
      
        let alert = UIAlertController(title: "Confirm order",
                                              message: "",
                                              preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self](action: UIAlertAction!) in
                    orderViewModel.postOrder(cartArray: placedOrders)
                }))

                alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: {(action: UIAlertAction!) in
                   


                }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: {(action: UIAlertAction!) in

            //function to execute when button is clicked
        }))
        self.present(alert, animated: true, completion: nil)
       
        
    }
}
extension CheckoutViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placedOrders.count
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let checkoutCell = tableView.dequeueReusableCell(withIdentifier: OrdersTableViewCell.identifier) as! OrdersTableViewCell
//        checkoutCell.addButton.isHidden = true
//        checkoutCell.subButton.isHidden = true
//        checkoutCell.addToWishlist.isHidden = true
//        checkoutCell.deleteProductBtn.isHidden = true
        
        checkoutCell.priceLabel.text = "$"+placedOrders[indexPath.row].itemPrice!
        checkoutCell.titleLabel.text = placedOrders[indexPath.row].itemName
        checkoutCell.quantityLabel.text = String(placedOrders[indexPath.row].itemQuantity)
        let urlImage = NSURL(string: (self.placedOrders[indexPath.row].itemImage!))
        let imagedata = NSData.init(contentsOf: urlImage! as URL)
        checkoutCell.imgView.image = UIImage(data: imagedata! as Data)
      
        
        return checkoutCell
    }
}

extension CheckoutViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height*0.5
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension CheckoutViewController{
    func setTotalPriceData(){
        if coupon == "5%"
        {
            guard let coupon = coupon else {return}
            discountLabel.text = coupon
            copounLabel.text = coupon  + " discount"
            guard let totalPrice = Manager.shared.getTotalPrice() else{return}
            subTotalLabel.text = String(totalPrice)
            result = (Double(String(subTotalLabel.text!))! + 10.00) * 0.95
            totalPriceLabel.text = String(result) + "USD"
            guard let paymentMethod = paymentMethod else {
                return
            }
            paymentLabel.text = paymentMethod
            deliveryTimeLAbel.text = Manager.shared.getUserName()
        }
        else if coupon == "10%"
        {
            guard let coupon = coupon else {return}
            discountLabel.text = coupon
            copounLabel.text = coupon  + " discount"
            guard let totalPrice = Manager.shared.getTotalPrice() else{return}
            subTotalLabel.text = String(totalPrice)
            result = (Double(String(subTotalLabel.text!))! + 10.00) * 0.9
            totalPriceLabel.text = String(result) + "USD"
            guard let paymentMethod = paymentMethod else {
                return
            }
            paymentLabel.text = paymentMethod
            deliveryTimeLAbel.text = Manager.shared.getUserName()
        }
        else if coupon == "15%"
        {
            guard let coupon = coupon else {return}
            discountLabel.text = coupon
            copounLabel.text = coupon  + " discount"
            guard let totalPrice = Manager.shared.getTotalPrice() else{return}
            subTotalLabel.text = String(totalPrice)
            result = ((Double(String(subTotalLabel.text!))! + 10.00) ) * 0.85
            totalPriceLabel.text = String(result) + "USD"
            guard let paymentMethod = paymentMethod else {
                return
            }
            paymentLabel.text = paymentMethod
            deliveryTimeLAbel.text = Manager.shared.getUserName()
        }
        else
        {
            guard let coupon = coupon else {return}
            discountLabel.text = coupon
            copounLabel.text = coupon  + " discount"
            guard let totalPrice = Manager.shared.getTotalPrice() else{return}
            subTotalLabel.text = String(totalPrice)
            result = Double(String(subTotalLabel.text!))! + 10.00
            totalPriceLabel.text = String(result) + "USD"
            guard let paymentMethod = paymentMethod else {
                return
            }
            paymentLabel.text = paymentMethod
            deliveryTimeLAbel.text = Manager.shared.getUserName()
        }
        }


}

//extension CheckoutViewController{
//    func setAddress(){
//        checkoutViewModel.getSelectedAddress { selectedAddress, error in
//            guard let selectedAddress = selectedAddress, error == nil else { return }
//            self.addressLabel.text = selectedAddress.firstAddress
//            self.cityLabel.text = selectedAddress.city
//            self.countryLabel.text = selectedAddress.country
//            self.phoneNumberLabel.text = selectedAddress.phoneNumber
//        }
//    }
//}
