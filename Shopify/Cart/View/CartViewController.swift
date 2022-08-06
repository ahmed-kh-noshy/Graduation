//
//  CartViewController.swift
//  BasicStructure
//
//  Created by Ibrahem's on 13/07/2022.
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var placeOrderButtonOutlet: UIButton!
    @IBOutlet weak var totalLabelContainerOutlet: UIView!
    @IBOutlet weak var emptyCartImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!

    var noConnectionImageView = UIImageView()

    var cartArray : [OrdersInCart] = []
//    var arrangedCartArray: [OrdersInCart] = []
    let cartViewModel = CartViewModel()

    var selectedIndexForNumberOfOrdersInCart = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNoInterNetConnectImage()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        selectedIndexForNumberOfOrdersInCart = tabBarController!.selectedIndex
     
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkNetworking()
        
        let tabItems = self.tabBarController?.tabBar.items as NSArray?
        let tabItem = tabItems![selectedIndexForNumberOfOrdersInCart] as! UITabBarItem
        tabItem.badgeValue = String(self.cartArray.count)
        
        checkCartIsEmpty()
        retriveCartItems()
        setCartItems()
        setTotalPrice()
        
        
        DispatchQueue.main.async {

            self.tableView.reloadData()
        }
       
    }
//MARK: - Last item in Cart Array
        

//MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartTableViewCell
     
        cell.productTitleLabel.text = cartArray[indexPath.row].itemName
        cell.productPriceLabel.text = cartArray[indexPath.row].itemPrice?.appending(" USD")

        let urlImage = NSURL(string: (self.cartArray[indexPath.row].itemImage ?? ""))
        let imagedata = NSData.init(contentsOf: urlImage! as URL)
             if imagedata != nil {
                 cell.productImageView.image = UIImage(data: imagedata! as Data)
        }

        cell.productQuantityLabel.text = String(cartArray[indexPath.row].itemQuantity)
        
//MARK: - Setup Functions for adding and substracting
        cell.addingItem = {
            self.cartViewModel.getSelectedItemInCart(productId: self.cartArray[indexPath.row].itemID) { selectedOrder, error in
                if selectedOrder != nil {
                    selectedOrder?.itemQuantity+=1
                }
                self.cartViewModel.saveProductToCart()
            }
            self.tableView.reloadData()
            self.setTotalPrice()
        }
        cell.subtractingItem = {
            if self.cartArray[indexPath.row].itemQuantity > 1 {
                self.cartViewModel.getSelectedItemInCart(productId: self.cartArray[indexPath.row].itemID) { selectedOrder, error in
                    if selectedOrder != nil {
                        selectedOrder?.itemQuantity-=1
                    }
                    self.cartViewModel.saveProductToCart()
                }
            }
            self.tableView.reloadData()
            self.setTotalPrice()
        }

        return cell
    }

//MARK: - Setup CartItemsFrom CoreData Functions
  
    func setCartItems(){
        cartViewModel.getSelectedProducts { orders, error in
            guard let orders = orders else {return}
            self.cartArray = orders
            self.tableView.reloadData()
        }
    }
    
    func checkCartIsEmpty(){
        if cartArray.count == 0 {
            tableView.isHidden = true
        }
    }
    
    func retriveCartItems(){
        cartViewModel.getItemsInCart { cartItems, error in
            guard let items = cartItems else {return}
            self.cartArray = items
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func setTotalPrice(){
        cartViewModel.calcTotalPrice { totalPrice in
            guard let totalPrice = totalPrice else { return }
            Manager.shared.setTotalPrice(totalPrice:totalPrice)
           
            let roundedPriceToTwoDecimal =  (totalPrice*100).rounded()/100
            
            self.totalValueLabel.text = String(roundedPriceToTwoDecimal) + " $"
        }
    }

    func showDeleteAlert(indexPath:IndexPath){
        let alert = UIAlertController(title: "Are you sure?", message: "Do You Want To remove this item from Cart", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [self] UIAlertAction in
            cartViewModel.deleteFromCoreData(indexPath: indexPath, cartItems: cartArray)
            self.cartArray.remove(at: indexPath.row)
     
            self.tableView.reloadData()
            if self.cartArray.count == 0 {
               
                self.tableView.isHidden = true
                self.tableView.reloadData()
                setTotalPrice()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


//MARK: - IBActions
    @IBAction func didTapPlaceOrder(_ sender: Any) {

        if cartArray.count == 0 {
            self.showAlertError(title: "No Items!", message: "There is no items to checkout, please go and select items you love")

        }else{
            checkIsFoundAddress()
        }
    }

    @IBAction func deleteItemButton(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else {
            return
        }
        showDeleteAlert(indexPath: indexPath)
         setTotalPrice()
    }
}


extension CartViewController{
    func goToCreateAddress(){
        let addAddressViewController = storyboard?.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        self.navigationController?.pushViewController(addAddressViewController, animated: true)
    }
//MARK: - SetupFor Addresses
    func goToSelectedAddress(){
                let chooseAddressViewController = storyboard?.instantiateViewController(withIdentifier: "ChooseAddressViewController") as! ChooseAddressViewController
                self.navigationController?.pushViewController(chooseAddressViewController, animated: true)

    }
    func checkIsFoundAddress(){
        if Manager.shared.checkFoundAddress() {
            goToSelectedAddress()
        }else{
            goToCreateAddress()
        }
    }
}



//MARK: - Check for Connection in CartViewController

extension CartViewController{
    
    func showAlertForInterNetConnection(){
        let alert = UIAlertController(title: "No Connection", message: "please check your internet connection !", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    func createNoInterNetConnectImage(){
        let image = UIImage(named: "internet")
        noConnectionImageView = UIImageView(image: image!)
       
        noConnectionImageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        noConnectionImageView.center = self.view.center
        view.addSubview(noConnectionImageView)
    }
    func checkNetworking(){
        CheckForNetworkManager.sharedInstance.checkNetworkConnection { isConnected in
            if !isConnected{
                self.tableView.isHidden = true
                self.totalValueLabel.isHidden = true
                self.totalValueLabel.isHidden = true
                self.totalLabelContainerOutlet.isHidden = true
                self.placeOrderButtonOutlet.isHidden = true
                self.noConnectionImageView.isHidden = false
                self.showAlertForInterNetConnection()
            }else{
                self.totalLabelContainerOutlet.isHidden = false
                self.totalValueLabel.isHidden = false
                self.placeOrderButtonOutlet.isHidden = false
                self.tableView.isHidden = false
                self.totalValueLabel.isHidden = false
                self.noConnectionImageView.isHidden = true
                
            }
        }
    }
}

