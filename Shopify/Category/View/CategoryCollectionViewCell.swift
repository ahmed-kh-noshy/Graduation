//
//  CategoryCollectionViewCell.swift
//  BasicStructure
//
//  Created by Ibrahem's on 04/07/2022.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    


    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        categoryImageView.layer.masksToBounds = true
        categoryImageView.layer.cornerRadius = 8
    }
    
    
    }
    
    
  

