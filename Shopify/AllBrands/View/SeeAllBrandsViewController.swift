//
//  SeeAllBrandsViewController.swift
//  BasicStructure
//
//  Created by Noshy on 08/07/2022.
//

import UIKit

class SeeAllBrandsViewController: UIViewController, UISearchBarDelegate, DeletionDelegate {
    
    

    @IBOutlet weak var seeAllBrandsCollectionView: UICollectionView!

    
    var brandName : String? = ""
    var productsArray = [Product]()
    var db = DBManager.sharedInstance
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var networkIndicator = UIActivityIndicatorView()
    var favouriteProducts  = [Favourite]()
    var i  = Favourite()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = brandName
        let brand = brandName?.replacingOccurrences(of: " ", with: "%20")
        addActivityIndicator()
        
        let categoryViewModel = CategoryViewModel(endpoint: "products.json?vendor=\(brand!)")
            categoryViewModel.fetchData()
            categoryViewModel.bindingData = {products , error in
                
                if let products = products {
                    self.productsArray = products
                    DispatchQueue.main.async {
                        self.seeAllBrandsCollectionView.reloadData()
                        self.networkIndicator.stopAnimating()
                    }
                }
                if let error = error {
                    print(error.localizedDescription)
                }
                
            }

        setUpUi()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        favouriteProducts = db.fetchData(appDelegate: self.appDelegate)
    }
    func setUpUi(){
        seeAllBrandsCollectionView.dataSource = self
        seeAllBrandsCollectionView.delegate   = self
        
        seeAllBrandsCollectionView.register(UINib(nibName: "ProductCellCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "ProductCellCollectionViewCell")
    }
    func addActivityIndicator(){
        networkIndicator.style = .medium
        networkIndicator.center = view.center
        networkIndicator.startAnimating()
        view.addSubview(networkIndicator)
    }
  

}
extension SeeAllBrandsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
        let cell = seeAllBrandsCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCellCollectionViewCell", for: indexPath) as! ProductCellCollectionViewCell
        let allVariants = productsArray[indexPath.row].variants
        let allPrices =  allVariants.map{$0.price}
        let price = allPrices[0]
        cell.titleLabel.text = productsArray[indexPath.row].handle
        cell.priceLabel.text = price + " $"
      
        
        let urlImag = NSURL(string: (productsArray[indexPath.row].image.src))
        let imagedata = NSData.init(contentsOf: urlImag! as URL)
        cell.productImageView.image = UIImage(data: imagedata! as Data)
        
        cell.addToFavourite = {
            let alert = UIAlertController(title: "", message: "Item Added To Favourites", preferredStyle: .alert)
            self.db.addProduct(productID: Int64(self.productsArray[indexPath.row].id),productName: self.productsArray[indexPath.row].handle,productImage: self.productsArray[indexPath.row].image.src, productDescription: self.productsArray[indexPath.row].bodyHTML, productPrice: price, appDelegate: self.appDelegate)
            self.present(alert, animated: true) {
                sleep(1)
                alert.dismiss(animated: true)
            }
        }
        
            cell.deleteFromFavourite = {
                let alert = UIAlertController(title: "", message: "Item removed from favourites", preferredStyle: .alert)
                for i in self.favouriteProducts{
                    print(i.productName!)
                    print(self.productsArray[indexPath.row].handle)
                    if i.productName == self.productsArray[indexPath.row].handle{
                            print("tracing before deleting")
                        self.db.delete(product: i, indexPath: indexPath, appDelegate: self.appDelegate, delegate: self)
                }
               
                    
                }
                
                
                self.present(alert, animated: true){
                    sleep(1)
                    alert.dismiss(animated: true)
                }
                
            }
            

        
            return cell

    }
        
}

extension SeeAllBrandsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pr = productsArray[indexPath.row].variants
        let price =  pr.map{$0.price}
        let pp = price[0]
        let productDetailViewController = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        productDetailViewController.product = productsArray[indexPath.row]
        productDetailViewController.price = pp + "$"
        productDetailViewController.productid = productsArray[indexPath.row].id
        self.navigationController?.pushViewController(productDetailViewController, animated: true)
        }
        
        
}

extension SeeAllBrandsViewController{
    func deleteProductAtIndexPath(indexPath: IndexPath) {
//        favouriteProducts.remove(at: indexPath.row)
        DispatchQueue.main.async {
           self.seeAllBrandsCollectionView.reloadData()
        }
    }
}
  
