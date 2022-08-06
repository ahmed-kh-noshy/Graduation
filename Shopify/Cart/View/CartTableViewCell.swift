//
//  CartTableViewCell.swift
//  BasicStructure
//
//  Created by Ibrahem's on 13/07/2022.
//

import UIKit



class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productQuantityLabel: UILabel!
//    @IBOutlet weak var stepper: UIStepper!
    
    var delegate: myDelegate?
    
    
    var addingItem : (()->())?
    var subtractingItem : (()->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.productQuantityLabel.text = "0"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
        
//    @IBAction func didTapStepper(_ sender: UIStepper) {
//        productQuantityLabel.text = Int(sender.value).description
//        delegate?.myDelegate(value: Int(sender.value), productName: productTitleLabel.text! )
//    }
    @IBAction func addQuantity(_ sender: UIButton) {
        addingItem?()
    }
    @IBAction func subQuantity(_ sender: UIButton) {
        subtractingItem?()
    }
}

protocol myDelegate {
    func myDelegate(value: Int, productName: String)
}
