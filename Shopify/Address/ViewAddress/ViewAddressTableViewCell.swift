//
//  ViewAddressTableViewCell.swift
//  BasicStructure
//
//  Created by Ibrahem's on 13/07/2022.
//

import UIKit

class ViewAddressTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var address1Label: UILabel!
  
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
  
    
//
//    selectedAddress.customerID = Int64(customerId)
//    selectedAddress.addID = Int64(addressID)
//    selectedAddress.firstAddress = address1
//    selectedAddress.city = city
//    selectedAddress.country = country
//    selectedAddress.customerName = name
//    selectedAddress.phoneNumber = phone
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
