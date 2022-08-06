//
//  MainViewCollectionViewCell.swift
//  MyFinalSportsApp
//
//  Created by Noshy on 20/06/2022.
//

import UIKit

class HomeViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var brandImage: UIImageView!

    func configureCell(with smart: SmartCollection ) {
        
        
        let urlImag = NSURL(string: (smart.image.src))
        let imagedata = NSData.init(contentsOf: urlImag! as URL)
             if imagedata != nil {
                 brandImage.image = UIImage(data: imagedata! as Data)
//                brandImage.layer.cornerRadius = 20
//                brandImage.clipsToBounds = true
//                brandImage.layer.masksToBounds = true
//                 brandImage.layer.borderWidth = 1
//    
        }
    }
    
//    func configureCell(with sport: Sport) {
//       sportName.text = sport.strSport
//        let urlImag = NSURL(string: (sport.strSportThumb))
//            let imagedata = NSData.init(contentsOf: urlImag! as URL)
//        if imagedata != nil {
//
//            sportImage.image = UIImage(data: imagedata! as Data)
//
//            sportImage.layer.cornerRadius = 20
//            sportImage.clipsToBounds = true
//            sportImage.layer.masksToBounds = true
//            imageContainer.layer.cornerRadius = 20
//
//        }
//    }
//
//    func configureCell(with sport: Sport) {
//       sportName.text = sport.strSport
//        let urlImag = NSURL(string: (sport.strSportThumb))
//            let imagedata = NSData.init(contentsOf: urlImag! as URL)
//        if imagedata != nil {
//
//            sportImage.image = UIImage(data: imagedata! as Data)
//
//            sportImage.layer.cornerRadius = 20
//            sportImage.clipsToBounds = true
//            sportImage.layer.masksToBounds = true
//            imageContainer.layer.cornerRadius = 20
//
//        }
//    }
    
}

