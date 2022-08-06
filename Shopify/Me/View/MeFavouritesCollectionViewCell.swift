//
//  MeFavouritesCollectionViewCell.swift
//  BasicStructure
//
//  Created by Ibrahem's on 15/07/2022.
//

import UIKit

class MeFavouritesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var favoriteProductName: UILabel!
    @IBOutlet weak var favoriteProductImage: UIImageView!
    
    var item: Int?
    var favoriteProducts = [Favourite]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setUpItems(item: Int,favoriteProducts: [Favourite]){
        self.item = item
        self.favoriteProducts = favoriteProducts
        
    }
}
