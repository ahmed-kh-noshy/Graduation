//
//  ShopingCartTableViewCell.swift
//  BasicStructure
//
//  Created by Ibrahem's on 05/07/2022.
//

import UIKit


protocol CartSelection {
    
    func addProductToCart(product : product, atIndex : Int)
}

class ShopingCartTableViewCell: UITableViewCell {


    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var variantTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    

   
    var product : product!
    private var counterValue = 1
    var productIndex = 0
    
    var cartSelectionDelegate: CartSelection?
  //  var calcQuantityDelegate: Quantity?

    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.layer.masksToBounds = true
        productImageView.layer.cornerRadius = 8
        deleteButton.setTitle("", for: .normal)
    
    }
  

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func minusAction(_ sender: Any) {
        
        if(counterValue != 1){
                   counterValue -= 1;
               }
               self.priceLabel.text = "\(counterValue)"
               product.price = counterValue
               cartSelectionDelegate?.addProductToCart(product: product, atIndex: productIndex)
    }
    
    @IBAction func plusAction(_ sender: Any) {
       
        counterValue += 1;
               self.priceLabel.text = "\(counterValue)"
        product.price = counterValue
               cartSelectionDelegate?.addProductToCart(product: product, atIndex: productIndex)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
     
   }
    
}


