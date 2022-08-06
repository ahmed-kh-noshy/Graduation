//
//  FavouriteCollectionViewCell.swift
//  BasicStructure
//
//  Created by Ibrahem's on 05/07/2022.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    var favoriteProducts = [Favourite]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var favoriteProductName: UILabel!
    @IBOutlet weak var favoriteProductImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
