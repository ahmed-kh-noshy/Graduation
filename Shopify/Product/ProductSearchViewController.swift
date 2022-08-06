//
//  ProductSearchViewController.swift
//  BasicStructure
//
//  Created by Ibrahem's on 05/07/2022.
//

import UIKit

class ProductSearchViewController: UIViewController {
    
    @IBOutlet weak var topOfCollectionViewConstraints: NSLayoutConstraint!
    @IBOutlet weak var filteringPricesContainerCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var sliderFilteringPriceLabel: UILabel!
    @IBOutlet weak var sliderContainer: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var isCommingFromBrand = false
    var brandId: Int?
    var brandName : String? = ""
    var productsArray = [Product]()
    var networkIndicator = UIActivityIndicatorView()
    var buttonIsSelected = false
    let searchController = UISearchController(searchResultsController: nil)
    var searching = false
    var searchItem = [Product]()
    var sliderStatus = false
    var sliderData = [Product]()
    var newSliderArray = [Product]()
    
    var priceFilter = 0.0
    let roundedPriceFilter = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        hideFilter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addActivityIndicator()
        let categoryViewModel = CategoryViewModel(endpoint: "products.json")
            categoryViewModel.fetchData()
            categoryViewModel.bindingData = {products , error in
                
                if let products = products {
                    self.productsArray = products
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.networkIndicator.stopAnimating()
                    }
                }
                if let error = error {
                    print(error.localizedDescription)
                }
                
            }


        self.title = "Find Products"
       
        navigationItem.searchController = searchController
        setUpUi()

        configureSearchController()
   
        slider.minimumValue = 20
        slider.maximumValue = 200
    }
    
//MARK: - Function for updatingUI
    func setUpUi(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ProductCellCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "ProductCellCollectionViewCell")
    }
    
    func addActivityIndicator(){
        networkIndicator.style = .medium
        networkIndicator.center = view.center
        networkIndicator.startAnimating()
        view.addSubview(networkIndicator)
    }
    
    private func configureSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search For Product"
    }
    
    
//MARK: - Animations Functions
    func buttonStatus() {
        if buttonIsSelected {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.4, animations: {
                self.filteringPricesContainerCenterXConstraint.constant = UIScreen.main.bounds.width
                self.topOfCollectionViewConstraints.constant = UIScreen.main.bounds.minX
                self.view.layoutIfNeeded()
            })

    }else{
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.4, animations: {
            self.filteringPricesContainerCenterXConstraint.constant = 0.0
            self.topOfCollectionViewConstraints.constant = 60.0
             
          self.view.layoutIfNeeded()
                })

        }
    }
    
    func hideFilter() {
        filteringPricesContainerCenterXConstraint.constant = UIScreen.main.bounds.width
        topOfCollectionViewConstraints.constant = UIScreen.main.bounds.minX
        
    }
    
    func showFilter() {
        filteringPricesContainerCenterXConstraint.constant = 0.0
        topOfCollectionViewConstraints.constant = 60.0
    }
    
    
//MARK: - IBActions
    @IBAction func filterProductsPrice(_ sender: UISlider) {
        
        let roundedPriceFilter = round(priceFilter)
     
        priceFilter = Double(sender.value)
       
        sliderFilteringPriceLabel.text = String("Price: \(roundedPriceFilter)")
        
        updateCollectionForSlider()

        print(sender.value)
        collectionView.reloadData()
        
        //        let priceFilter = String(Int(sender.value))
        //        sliderFilteringPriceLabel.text = String("Price: \(priceFilter)")
    }
   
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        
        buttonStatus()
        buttonIsSelected = !buttonIsSelected

    }
    


}
extension ProductSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchResultsUpdating {
  
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchItem.removeAll()
        collectionView.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchText  = searchController.searchBar.text!
        
        if !searchText.isEmpty {
            searching = true
            searchItem.removeAll()
            for item in productsArray {
                if item.handle.lowercased().contains(searchText.lowercased()) {
                    searchItem.append(item)
                }
            }
        }
        else {
            searching = false
            searchItem.removeAll()
            searchItem = productsArray
        }
        collectionView.reloadData()
    }

    func updateCollectionForSlider() {
        if sliderStatus {
            sliderStatus = false
            sliderData.removeAll()
            for item in productsArray {
               let allVariantsArray = item.variants
                let productsPriceArray =  allVariantsArray.map{$0.price}
                let selectedProductPrice = productsPriceArray[0]
                
             //   print("tracing price\(Double(selectedProductPrice)!)")
                if Double(selectedProductPrice) == roundedPriceFilter {
                    
                    sliderData.append(item)
                }
            }
        //    print("tracing price\(sliderData)")
            
            collectionView.reloadData()
        }
        else {
            sliderStatus = true
            sliderData.removeAll()
            sliderData = productsArray
        }
        collectionView.reloadData()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching {
            return searchItem.count
        }
        else if sliderStatus {
            return sliderData.count
        }
        else{
            return productsArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCellCollectionViewCell", for: indexPath) as! ProductCellCollectionViewCell
        if searching {
     
            let allVariantsArray = searchItem[indexPath.row].variants
            let productsPriceArray =  allVariantsArray.map{$0.price}
            let selectedProductPrice = productsPriceArray[0]
            cell.titleLabel.text = searchItem[indexPath.row].handle
            cell.priceLabel.text = selectedProductPrice + "$"
          
            
            let urlImag = NSURL(string: (searchItem[indexPath.row].image.src))
            let imagedata = NSData.init(contentsOf: urlImag! as URL)
            cell.productImageView.image = UIImage(data: imagedata! as Data)
          
        }
        else if sliderStatus {
            
            
            let allVariantsArray = sliderData[indexPath.row].variants
            let productsPriceArray =  allVariantsArray.map{$0.price}
            let selectedProductPrice = productsPriceArray[0]
            cell.titleLabel.text = sliderData[indexPath.row].handle
         
            cell.priceLabel.text = selectedProductPrice + "$"
            
            let urlImag = NSURL(string: (sliderData[indexPath.row].image.src))
            let imagedata = NSData.init(contentsOf: urlImag! as URL)
            cell.productImageView.image = UIImage(data: imagedata! as Data)
        }
        else {
            let allVariantsArray = productsArray[indexPath.row].variants
            let productsPriceArray =  allVariantsArray.map{$0.price}
            let selectedProductPrice = productsPriceArray[0]
            cell.titleLabel.text = productsArray[indexPath.row].handle
            cell.priceLabel.text = selectedProductPrice + "$"
          
            
            let urlImag = NSURL(string: (productsArray[indexPath.row].image.src))
            let imagedata = NSData.init(contentsOf: urlImag! as URL)
            cell.productImageView.image = UIImage(data: imagedata! as Data)
        }
      
        return cell
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
        let pr = productsArray[indexPath.row].variants
        let price =  pr.map{$0.price}
        let pp = price[0]
        let productVC = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        productVC.product = productsArray[indexPath.row]
        productVC.price = pp + "$"
     
        
        self.navigationController?.pushViewController(productVC, animated: true)
      //  self.navigationController?.pushViewController(productDetailViewController, animated: true)
    }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
            return CGSize(width: size, height: size)
        }

}
//extension ProductSearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchText = searchController.searchBar.text!
//        if !searchText.isEmpty {
//            print("FBGDFS")
//        }
//    }
//
//
//}

