//
//  ShoppingCartViewController.swift
//  BasicStructure
//
//  Created by Ibrahem's on 05/07/2022.
//

import UIKit


class ShoppingCartViewController: UIViewController, CartSelection {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var productArray = [product]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        for _ in 0...3{
                  productArray.append(product(price: 1))
              }
        tableView.allowsSelection = false
        calculateTotal()
        
        
        setupTableView()
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ShopingCartTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: "ShopingCartTableViewCell")
    }
    
    func addProductToCart(product: product, atIndex: Int) {
         productArray[atIndex] = product

         calculateTotal()
     }
    
    func calculateTotal()
        {
            var totalValue = 0
            for objProduct in productArray {

                totalValue += objProduct.price
                
            }


            self.totalPriceLabel.text = "\(totalValue) $"

        }

   
    
    //totalPriceLabel.text = Currency.stringFrom(totalPrice)
            
    @IBAction func checkOutAction(_ sender: Any) {
        
        let chooseAddressViewController = storyboard?.instantiateViewController(withIdentifier: "ChooseAddressViewController") as! ChooseAddressViewController
        self.navigationController?.pushViewController(chooseAddressViewController, animated: true)
     
    }
}
extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopingCartTableViewCell", for: indexPath) as! ShopingCartTableViewCell
        
        
        
//        cell.configureCell(with: productsArray[indexPath.row])
        cell.productTitleLabel.text = "Test"
        cell.product = productArray[indexPath.row]
        cell.quantityLabel.text = "\(cell.product.price)"
        cell.productIndex = indexPath.row
        cell.cartSelectionDelegate = self
        cell.priceLabel.text = "200"
        
        
        
        return cell
    }
}

struct product {
   var price = 100
}

