//
//  ChooseAddressTableViewCell.swift
//  BasicStructure
//
//  Created by Ibrahem's on 08/07/2022.
//

import UIKit

//protocol ChooseAddressTableViewCellDelegate: AnyObject {
//    func didTapEditButton(with title: String)
//}
class ChooseAddressTableViewCell: UITableViewCell {
//
//    @IBOutlet weak var editButtonOutlet: UIButton!
//
    @IBOutlet weak var firstAddressLabel: UILabel!
    @IBOutlet weak var countryAndCityLabelForAddress: UILabel!
    @IBOutlet weak var customerName: UILabel!
 
//    private var title: String = ""
    
    
//    var delegate: ChooseAddressTableViewCellDelegate!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    func configure(with title: String) {
//        editButtonOutlet.setTitle(title, for: .normal)
//        self.title = title
//    }
//    @IBAction func editAddressButtonPressed(_ sender: UIButton) {
//        editButtonOutlet.setTitle(title, for: .normal)
//        delegate?.didTapEditButton(with: self.title)
//
//    }
    
  
}
