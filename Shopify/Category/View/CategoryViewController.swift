//
//  CategoryViewController.swift
//  BasicStructure
//
//  Created by Noshy on 04/07/2022.
//

import UIKit

class CategoryViewController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating{
    
    
    
    
    let searchController = UISearchController()

    var newArray = [Product]()
    var productsArray = [Product]()
    var menArray = [Product]()
    var menSearchArray = [Product]()
    var womenArray = [Product]()
    var womenSearchArray = [Product]()
    var kidArray = [Product]()
    var kidSearchArray = [Product]()
    var saleArray = [Product]()
    var saleSearchArray = [Product]()
    var filter = false
    var index : Int = 0
    var networkIndicator = UIActivityIndicatorView()
    var searching = false
    var allSearchItem = [Product]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var db = DBManager.sharedInstance
    var favouriteProducts  = [Favourite]()
    var i  = Favourite()
    
    var noInternetimageView = UIImageView()
    
    @IBOutlet weak var categoriesDetailsCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        networkIndicator.stopAnimating()
        addActivityIndicator()
        createNoInterNetConnectImage()
        let categoryViewModel = CategoryViewModel(endpoint: "products.json")
            categoryViewModel.fetchData()
            categoryViewModel.bindingData = {products , error in
                
                if let products = products {
                    self.productsArray = products
                    DispatchQueue.main.async {
                        self.categoriesDetailsCollectionView.reloadData()
                        self.networkIndicator.stopAnimating()
                    }
                }
                if let error = error {
                    print(error.localizedDescription)
                }
                
            }
        fetchMen()
        fetchWoman()
        fetchKid()
        fetchSale()
        
        setUpUi()
        initSearchController()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkNetworking()
        
         favouriteProducts  = db.fetchData(appDelegate: self.appDelegate)
    }
    //MARK: - Rendering UI
        
        func setUpUi(){
            categoriesDetailsCollectionView.dataSource = self
            categoriesDetailsCollectionView.delegate   = self
            categoriesDetailsCollectionView.register(UINib(nibName: "ProductCellCollectionViewCell", bundle: nil),
                                    forCellWithReuseIdentifier: "ProductCellCollectionViewCell")
        }
        func addActivityIndicator(){
            networkIndicator.style = .medium
            networkIndicator.center = view.center
            networkIndicator.startAnimating()
            view.addSubview(networkIndicator)
        }
        //MARK: - fetchData Functions
        func fetchMen(){
            addActivityIndicator()
            let menCategoryViewModel = CategoryViewModel(endpoint: "products.json?collection_id=409147474134")
                menCategoryViewModel.fetchData()
                menCategoryViewModel.bindingData = {products , error in

                    if let products = products {
                        self.menArray = products
                        DispatchQueue.main.async {
                            print("the menArray is \(self.menArray)")
                            self.categoriesDetailsCollectionView.reloadData()
                            self.networkIndicator.stopAnimating()
                        }
                    }
                    if let error = error {
                        print(error.localizedDescription)
                    }

                }

        }
        func fetchWoman(){
            addActivityIndicator()
            let womenCategoryViewModel = CategoryViewModel(endpoint: "products.json?collection_id=409147506902")
                womenCategoryViewModel.fetchData()
                womenCategoryViewModel.bindingData = {products , error in

                    if let products = products {
                        self.womenArray = products
                        DispatchQueue.main.async {
                            print("the womenArray is \(self.womenArray)")
                            self.categoriesDetailsCollectionView.reloadData()
                            self.networkIndicator.stopAnimating()
                        }
                    }
                    if let error = error {
                        print(error.localizedDescription)
                    }

                }

        }
        func fetchKid(){
            addActivityIndicator()
            let kidCategoryViewModel = CategoryViewModel(endpoint: "products.json?collection_id=409147539670")
                kidCategoryViewModel.fetchData()
                kidCategoryViewModel.bindingData = {products , error in

                    if let products = products {
                        self.kidArray = products
                        DispatchQueue.main.async {
                            print("the kidArray is \(self.kidArray)")
                            self.categoriesDetailsCollectionView.reloadData()
                            self.networkIndicator.stopAnimating()
                        }
                    }
                    if let error = error {
                        print(error.localizedDescription)
                    }

                }
            print("the kidArray is \(kidArray)")
        }
        func fetchSale(){
            addActivityIndicator()
            let saleCategoryViewModel = CategoryViewModel(endpoint: "products.json?collection_id=409147605206")
                saleCategoryViewModel.fetchData()
                saleCategoryViewModel.bindingData = {products , error in

                    if let products = products {
                        self.saleArray = products
                        DispatchQueue.main.async {
                            print("the saleArray is \(self.saleArray)")
                            self.categoriesDetailsCollectionView.reloadData()
                            self.networkIndicator.stopAnimating()
                        }
                    }
                    if let error = error {
                        print(error.localizedDescription)
                    }

                }

        }
    func getProductPrice(product :Product) -> String{
        
        let allVariants = product.variants
        let productPrices =  allVariants.map{$0.price}
        let price = productPrices[0]
        return price
    }
        
    //MARK: - setup Search Functions
        func initSearchController()
        {
            searchController.loadViewIfNeeded()
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.enablesReturnKeyAutomatically = false
            searchController.searchBar.returnKeyType = UIReturnKeyType.done
            definesPresentationContext = true
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            self.searchController.searchBar.showsScopeBar = true
            searchController.searchBar.scopeButtonTitles = ["All","Men", "Women", "Kid", "Sale"]
            searchController.searchBar.delegate = self
        }
        func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
            switch selectedScope{
            case 0:
                index = selectedScope
            case 1:
                index = selectedScope
                break
            case 2:
                index = selectedScope
                break
            case 3:
                index = selectedScope
                break
            case 4:
                index = selectedScope
                break
            default:
                break
            }
        }
        func updateSearchResults(for searchController: UISearchController) {
            let searchBar = searchController.searchBar
            let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
            let searchText = searchBar.text!
            filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: scopeButton)
        }
//MARK: - Handling Search In Category
        func filterForSearchTextAndScopeButton(searchText: String, scopeButton : String = "All")
        {


            newArray = productsArray.filter
            {
                item in
                let scopeMatch = (scopeButton == "All" || item.handle.lowercased().contains(scopeButton.lowercased()))
                if(searchController.searchBar.text != "")
                {
                    let searchTextMatch = item.handle.lowercased().contains(searchText.lowercased())

                    return scopeMatch && searchTextMatch
                }
                else
                {
                    return scopeMatch
                }
            }
            categoriesDetailsCollectionView.reloadData()
        }
    
    
    
    
    
    
    
    
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searching = false
            allSearchItem.removeAll()
            categoriesDetailsCollectionView.reloadData()
        }
    }
    //MARK: - Rendering collection View
    extension CategoryViewController: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

            if(searchController.isActive)
            {
                return newArray.count
            }else{
                switch index {
                case 0:
                    return productsArray.count

                case 1:
                    return menArray.count

                case 2:
                    return womenArray.count

                case 3:
                    return kidArray.count

                case 4:
                    return saleArray.count
                default:
                    print("ERROR")
                    return productsArray.count
                }
            }
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = categoriesDetailsCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCellCollectionViewCell", for: indexPath) as! ProductCellCollectionViewCell


            let thisProduct: Product!
            
            if(searchController.isActive)
            {
                thisProduct = newArray[indexPath.row]
            }
            else
            {
                switch index{
                case 0:
                    thisProduct = productsArray[indexPath.row]
                    
                case 1:
                    thisProduct = menArray[indexPath.row]
                    
                case 2:
                    thisProduct = womenArray[indexPath.row]
                    
                case 3:
                    thisProduct = kidArray[indexPath.row]
                    
                case 4:
                    thisProduct = saleArray[indexPath.row]
                    
                default:
                    thisProduct = productsArray[indexPath.row]
                }
            }
            
        cell.titleLabel.text = thisProduct.title
        cell.priceLabel.text = getProductPrice(product: thisProduct) + "$"


        let urlImag = NSURL(string: (thisProduct.image.src))
        let imagedata = NSData.init(contentsOf: urlImag! as URL)
        cell.productImageView.image = UIImage(data: imagedata! as Data)
            cell.addToFavourite = {
                let alert = UIAlertController(title: "", message: "Item Added To Favourites", preferredStyle: .alert)
                self.db.addProduct(productID: Int64(self.productsArray[indexPath.row].id),productName: thisProduct.handle,productImage: thisProduct.image.src, productDescription: thisProduct.bodyHTML, productPrice: self.getProductPrice(product: thisProduct), appDelegate: self.appDelegate)
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

    extension CategoryViewController: UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
            return CGSize(width: size, height: size)
        }
        
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let productDetailViewController = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            
            
            
            switch index{
            case 0:
                productDetailViewController.productid = productsArray[indexPath.row].id
                productDetailViewController.product = productsArray[indexPath.row]
                productDetailViewController.price = getProductPrice(product: productsArray[indexPath.row]) + "$"
                
            case 1:
                productDetailViewController.productid = menArray[indexPath.row].id
                productDetailViewController.product = menArray[indexPath.row]
                productDetailViewController.price = getProductPrice(product: menArray[indexPath.row]) + "$"
               
            case 2:
                productDetailViewController.productid = womenArray[indexPath.row].id
                productDetailViewController.product = womenArray[indexPath.row]
                productDetailViewController.price = getProductPrice(product: womenArray[indexPath.row]) + "$"
            case 3:
                productDetailViewController.productid = kidArray[indexPath.row].id
                productDetailViewController.product = kidArray[indexPath.row]
                productDetailViewController.price = getProductPrice(product: kidArray[indexPath.row]) + "$"
                
            case 4:
                productDetailViewController.productid = saleArray[indexPath.row].id
                productDetailViewController.product = saleArray[indexPath.row]
                productDetailViewController.price = getProductPrice(product: saleArray[indexPath.row]) + "$"
                
            default :
                productDetailViewController.productid = productsArray[indexPath.row].id
                productDetailViewController.product = productsArray[indexPath.row]
                productDetailViewController.price = getProductPrice(product: productsArray[indexPath.row]) + "$"
               
            }
               
                self.navigationController?.pushViewController(productDetailViewController, animated: true)
            }
            
    }
   
extension CategoryViewController: DeletionDelegate{
    
    func deleteProductAtIndexPath(indexPath: IndexPath) {
      //  productsArray.remove(at: indexPath.item)
        DispatchQueue.main.async {
            self.categoriesDetailsCollectionView.reloadData()
        }
    }
}

//MARK: - Check for Connection in CategoryViewController

extension CategoryViewController{
    
    func showAlertForInterNetConnection(){
        let alert = UIAlertController(title: "network is not connected", message: "please, check your internet connection for using app..", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okBtn)
        self.present(alert, animated: true, completion: nil)
    }
    func createNoInterNetConnectImage(){
        let image = UIImage(named: "internet")
        noInternetimageView = UIImageView(image: image!)
       
        noInternetimageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        noInternetimageView.center = self.view.center
        view.addSubview(noInternetimageView)
    }
    func checkNetworking(){
        CheckForNetworkManager.sharedInstance.checkNetworkConnection { isConnected in
            if !isConnected{
                self.categoriesDetailsCollectionView.isHidden = true
                self.searchController.searchBar.isHidden = true
           
                self.noInternetimageView.isHidden = false
                self.showAlertForInterNetConnection()
            }else{
              
                self.noInternetimageView.isHidden = true
               
                self.categoriesDetailsCollectionView.isHidden = false
                self.searchController.searchBar.isHidden = false
               
               
            }
        }
    }
}

