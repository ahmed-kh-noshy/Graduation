//
//  ProductCellCollectionViewCell.swift
//  BasicStructure
//
//  Created by Ibrahem's on 05/07/2022.
//

import UIKit

class ProductCellCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var wishListContainerView: UIView!
    @IBOutlet weak var wishListIcon: UIImageView!
  

        var addToFavourite : (()->())?
        var deleteFromFavourite : (()->())?
        var addToFavouriteFromBrands : (()->())?
        var isClicked: Bool = false
  
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
               
        wishListContainerView.layer.cornerRadius = 15
        wishListContainerView.clipsToBounds = true
        wishListContainerView.layer.masksToBounds = true
     
    }
    @IBAction func wishListAction(_ sender: Any) {
        if(isClicked == false){
                   self.wishListIcon.tintColor = UIColor.red
                   wishListIcon.image = UIImage(systemName: "heart.fill")
                   print("Item added to favourites")
                   addToFavourite?()
                   addToFavouriteFromBrands?()
                   isClicked = true
               }
               else{
                   self.wishListIcon.tintColor = UIColor.systemBlue
                   wishListIcon.image = UIImage(systemName: "heart")
                   deleteFromFavourite?()
                   print("Item removed from favourites")
                       self.isClicked = false

               }


           }
          
        
    }

