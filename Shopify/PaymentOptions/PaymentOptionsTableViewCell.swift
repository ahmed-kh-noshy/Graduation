//
//  PaymentOptionsTableViewCell.swift
//  BasicStructure
//
//  Created by Ibrahem's on 08/07/2022.
//

import UIKit

class PaymentOptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var paymentSelectionButtonOutlet: UIImageView!
    
    var isClicked = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func paymentSelectionButtonPressed(_ sender: UIButton) {
        
        if (isClicked == false) {
            

            paymentSelectionButtonOutlet.image = UIImage(systemName: "circle.fill")
            
            isClicked = true
        }
        else{
            paymentSelectionButtonOutlet.image = UIImage(systemName: "circle")
            isClicked = false
        }
        
        
    }
}
