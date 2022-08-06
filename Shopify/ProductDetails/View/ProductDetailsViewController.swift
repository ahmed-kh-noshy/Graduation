//
//  ProductDetailsViewController.swift
//  BasicStructure
//
//  Created by Ibrahem's on 06/07/2022.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDetailsCollectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let db = DBManager.sharedInstance
    var productsFav =  [Favourite]()
    var productNameArr: [String] = []
    var currentIndex = 0
    var isClicked: Bool = false
    var price : String?
    var productid : Int?


    
    let orderViewModel = CartViewModel()
    var product : Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        let productViewModel = ProductDetailsViewModel(endpoint: "products/\(productid!).json")
        productViewModel.fetchData()
        productViewModel.bindingData = {products , error in
                
                if let products = products {
                    self.product = products
                 
                }
                if let error = error {
                    print(error.localizedDescription)
                }
                
            }
       
        setUpUi()
        setUpElementes()
    }
    override func viewWillAppear(_ animated: Bool) {
        productsFav = db.fetchData(appDelegate: appDelegate)
    }
    func setUpUi(){
        pageController.addTarget(self, action: #selector(moveToNextIndex), for: .valueChanged)
        pageController.numberOfPages = product?.images.count ?? 3

        productDetailsCollectionView.delegate = self
        productDetailsCollectionView.dataSource  = self
        productDetailsCollectionView.isPagingEnabled = true
    }
    
    func setUpElementes(){
  
        productName.text = product?.handle
        productPrice.text = price
        productDescription.text = product?.bodyHTML
    }
//    func createProduct() -> Product {
//        product?.id = 
//    }
    
    @objc func moveToNextIndex(_ sender: UIPageControl) {
        
        
        
        if currentIndex < (product?.images.count)! - 1 {
            currentIndex += 1
        }else{
            currentIndex = 0
        }
        
        productDetailsCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageController.currentPage = currentIndex
    }
    @IBAction func addToBagButton(_ sender: UIButton) {
        
        
        orderViewModel.checkIfItemInCart = {
            let alert = UIAlertController(title: "", message: "Item Already In Shopping Cart", preferredStyle: .alert)
            self.present(alert, animated: true) {
                sleep(1)
               alert.dismiss(animated: true)
            }
        }

        orderViewModel.addItemsToCart(product: product!)
        
        let alert = UIAlertController(title: "", message: "Item Added To ShoppingCart", preferredStyle: .alert)
        present(alert, animated: true) {
            sleep(1)
           alert.dismiss(animated: true)
        }
        
    }
    
  

   
    @IBAction func addToFavourite(_ sender: UIButton) {
        
       print("\(productsFav.count)")
        for item in 0..<productsFav.count{
            productNameArr.append(productsFav[item].productName ?? "")
            print(productNameArr)
        }
        if ((productNameArr.contains(productName.text ?? ""))){
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            let alert = UIAlertController(title: "", message: "Item Removed From Favourites", preferredStyle: .alert)
            db.deleteFavouriteProduct(deletedData: product!)

            present(alert, animated: true) {
                sleep(1)
               alert.dismiss(animated: true)
            }
        }
        else{
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            let alert = UIAlertController(title: "", message: "Item Added To Favourites", preferredStyle: .alert)
            db.addProduct(productID: Int64(product!.id), productName: product!.handle, productImage: product!.image.src, productDescription: product!.bodyHTML, productPrice: price!, appDelegate: appDelegate)
            present(alert, animated: true) {
                sleep(1)
               alert.dismiss(animated: true)
            }
            
        }
}
}
extension ProductDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.images.count ?? 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let productDetailsCell = productDetailsCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailsCollectionViewCell", for: indexPath) as! ProductDetailsCollectionViewCell
        let urlImage = NSURL(string: (self.product?.images[indexPath.row].src ?? ""))

                let imagedata = NSData.init(contentsOf: urlImage! as URL)

                     if imagedata != nil {

                         productDetailsCell.ProductDetailsImages.image = UIImage(data: imagedata! as Data)
                         

                }
//        productDetailsCell.ProductDetailsImages.loadFrom(URLAddress: (product?.images[indexPath.row].src)!)
//        productDetailsCell.ProductDetailsImages.image = product?.images[indexPath.row].src
        
        return productDetailsCell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
          let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
          let index = scrollView.contentOffset.x / witdh
          let roundedIndex = round(index)
          self.pageController?.currentPage = Int(roundedIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: productDetailsCollectionView.layer.frame.width, height: productDetailsCollectionView.layer.frame.height)
    }
    
}

//extension ProductDetailsViewController: DeletionDelegate{
//
//    func deleteProductAtIndexPath(indexPath: IndexPath) {
//        productsFav.remove(at: indexPath.item)
//        DispatchQueue.main.async {
//        }
//    }
//}
