//
//  FavouriteViewController.swift
//  BasicStructure
//
//  Created by Ibrahem's on 05/07/2022.
//

import UIKit

class FavoriteViewController: UIViewController, DeletionDelegate {
    

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var favoriteProducts = [Favourite]()
    let db = DBManager.sharedInstance
    var item: Int?
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpFavoriteCollectionView()
    }
    

    func setUpFavoriteCollectionView(){
    favoriteCollectionView.delegate = self
    favoriteCollectionView.dataSource = self
//    favoriteCollectionView.register(UINib(nibName: "FavoriteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FavoriteCollectionViewCell")
        
}
   @IBAction func deleteProductButton(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: favoriteCollectionView)
        guard let indexPath = favoriteCollectionView.indexPathForItem(at: point) else {return}
       let alert = UIAlertController(title: "", message: "Item Removed From Favourites", preferredStyle: .alert)
       db.delete(product: favoriteProducts[indexPath.item], indexPath: indexPath , appDelegate: appDelegate, delegate: self)
       self.favoriteCollectionView.reloadData()
       self.present(alert, animated: true)
       sleep(1)
       alert.dismiss(animated: true)
////        favoriteProducts.remove(at: indexPath.item)
////        //favouriteCollectionView.deleteRows(at: [indexPath], with: .left)
////        favoriteCollectionView.deleteItems(at: [indexPath])
   }

}
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource 
{
    override func viewWillAppear(_ animated: Bool) {
            favoriteProducts = db.fetchData(appDelegate: appDelegate)
        favoriteCollectionView.reloadData()
        if favoriteProducts.isEmpty{
            let alert = UIAlertController(title: "Warning", message: "Go to Products and Add Some ;)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
            return CGSize(width: size, height: size)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteProducts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionViewCell", for: indexPath) as! FavoriteCollectionViewCell
        cell.favoriteProductImage.loadFrom(URLAddress: favoriteProducts[indexPath.item].productImage ?? "")
        cell.favoriteProductName.text = favoriteProducts[indexPath.item].productName
        
        if let deleteButton = cell.contentView.viewWithTag(102) as? UIButton {
            deleteButton.addTarget(self, action: #selector(deleteProductButton(_ :)), for: .touchUpInside)
        }
        
        
        return cell
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let size = (favouriteCollectionView.frame.width - 8) / 2
//        return CGSize(width: size, height: size + 50)
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ProductDetailesVC = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        ProductDetailesVC.productid = Int(favoriteProducts[indexPath.row].productID)
        ProductDetailesVC.price = favoriteProducts[indexPath.item].productPrice
        
        present(ProductDetailesVC, animated: true)
        
    }
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}

extension FavoriteViewController{
    
    func deleteProductAtIndexPath(indexPath: IndexPath) {
        favoriteProducts.remove(at: indexPath.item)
        DispatchQueue.main.async {
            self.favoriteCollectionView.reloadData()
        }
    }
    
}
