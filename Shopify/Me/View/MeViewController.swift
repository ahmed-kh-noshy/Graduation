//
//  MeViewController.swift
//  BasicStructure
//
//  Created by Ibrahem's on 05/07/2022.


import UIKit

class MeViewController: UIViewController {
    @IBOutlet weak var vssgs: UIBarButtonItem!
    
    @IBOutlet weak var settingsButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var showAllOrdersOutlet: UIView!
    @IBOutlet weak var showAllFavouritesViewOutlet: UIView!
    @IBOutlet weak var greetingContainer: UIView!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var favouritesCollectionForMeViewController: UICollectionView!
    @IBOutlet weak var ordersForMeViewController: UITableView!

    var greeting = ""
    var userName = Manager.shared.getUserName() ?? "Guest"
    

    var orderArray: [Order] = []
    let myOrdersViewmodel = MyOrdersViewModel()

    var lastThreeItemsInOrders = [Order]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var allFavoriteProducts = [Favourite]()
    var  favorite = [Favourite]()
    let db = DBManager.sharedInstance
    var item: Int?
    var noInternetimageView = UIImageView()
    
    //MARK: - check For Login

    override func viewDidLoad() {
        super.viewDidLoad()
//        createNoInterNetConnectImage()
        self.title = "My Profile"


        setupfavouriteCollectionView()

        greetingLogic()
        setupTableView()
        onMyOrdersSucces()



        Manager.shared.checkUserIsLogged { userLogged in
            if userLogged{
                self.goToMe()
              
            }else{
                self.goToLoginPage()


            }
        }
    }


    func onMyOrdersSucces(){

        self.orderArray = myOrdersViewmodel.orders
        self.ordersForMeViewController.reloadData()
//        DispatchQueue.main.async {
//            self.ordersForMeViewController.reloadData()
//        }

    }
    func onFailure(){
        let alert = UIAlertController(title: "Error", message: myOrdersViewmodel.showError, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }


    override func viewWillAppear(_ animated: Bool) {
        
        createNoInterNetConnectImage()
        self.checkNetworking()
       
        self.navigationItem.hidesBackButton = true
        myOrdersViewmodel.bindSuccessToView = {
            self.onMyOrdersSucces()
        }

        myOrdersViewmodel.bindFailedToView = {
            self.onFailure()
        }
        allFavoriteProducts = db.fetchData(appDelegate: appDelegate)
        favouritesCollectionForMeViewController.reloadData()
        lastThreeItemsInOrders = orderArray.suffix(3)
    }


    //MARK: - greeting Function
        func greetingLogic() {
              let date = NSDate()
              let calendar = NSCalendar.current
              let currentHour = calendar.component(.hour, from: date as Date)
              let hourInt = Int(currentHour.description)!

              if hourInt >= 12 && hourInt <= 16 {
                  greeting = "Good Afternoon, \(userName)"
              }
              else if hourInt >= 7 && hourInt <= 12 {
                  greeting = "Good Morning, \(userName)"
              }
              else if hourInt >= 16 && hourInt <= 20 {
                  greeting = "Good Evening, \(userName)"
              }
              else if hourInt >= 20 && hourInt <= 24 {
                  greeting = "Good Night, \(userName)"
              }
            else{
                greeting = "Hello, \(userName)"
            }

            greetingLabel.text = greeting
            greetingContainer.layer.borderWidth = 0.5
            greetingContainer.layer.cornerRadius = 10
            greetingContainer.clipsToBounds = true
          }



    //MARK: - ordersForMeViewController setup Function
    func setupTableView() {
        ordersForMeViewController.delegate = self
        ordersForMeViewController.dataSource = self

        ordersForMeViewController.register(UINib(nibName: "MyOrderTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: "MyOrderTableViewCell")

        ordersForMeViewController.layer.borderWidth = 0.5
        ordersForMeViewController.layer.cornerRadius = 10
        ordersForMeViewController.clipsToBounds = true
    }
    //MARK: - favouritesCollectionForMeViewController setup Function
    func setupfavouriteCollectionView(){
        favouritesCollectionForMeViewController.delegate = self
        favouritesCollectionForMeViewController.dataSource = self

        favouritesCollectionForMeViewController.layer.borderWidth = 0.5
        favouritesCollectionForMeViewController.layer.cornerRadius = 10
        favouritesCollectionForMeViewController.clipsToBounds = true
}

    //MARK: - IBACTIONS
    @IBAction func showAllOrdersbutton(_ sender: UIButton) {

        let ordersScreen = self.storyboard?.instantiateViewController(withIdentifier: "MyOrderViewController") as! MyOrderViewController


        self.navigationController?.pushViewController(ordersScreen, animated: true)

    }
    @IBAction func showAllFavouritesButton(_ sender: UIButton) {

        let favoritesScreen = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController


        self.navigationController?.pushViewController(favoritesScreen, animated: true)
    }

    @IBAction func settingsButton(_ sender: UIBarButtonItem) {

           let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsTableViewController") as! SettingsTableViewController
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }

   
}
extension MeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return lastThreeItemsInOrders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderTableViewCell", for: indexPath) as! MyOrderTableViewCell
        cell.dateLabel.text = orderArray[indexPath.row].created_at
        cell.priceLabel.text = "Paid" + orderArray[indexPath.row].current_total_price! + " USD"
        cell.orderIDLabel.text = ("Order ID : \(orderArray[indexPath.row].id ?? 0)")
        return cell
    }

    }

//MARK: - favouritesCollectionForMeViewController
extension MeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allFavoriteProducts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeFavouritesCollectionViewCell", for: indexPath) as! MeFavouritesCollectionViewCell

        cell.favoriteProductImage.loadFrom(URLAddress: allFavoriteProducts[indexPath.item].productImage ?? "")
        cell.favoriteProductName.text = allFavoriteProducts[indexPath.item].productName
        item = indexPath.item

        cell.setUpItems(item: item ?? 0, favoriteProducts: allFavoriteProducts)




        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
}

//MARK: - Check For Login Functions
extension MeViewController {

func goToMe(){


    self.navigationItem.setHidesBackButton(true, animated: true)
   // self.dismiss(animated: true)

    
}
func goToLoginPage(){


       let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "GuestProfileViewController") as! GuestProfileViewController


    self.navigationItem.setHidesBackButton(true, animated: true)
    self.navigationController?.pushViewController(loginVC, animated: true)

}
}
//MARK: - Check for Connection in MeViewController

extension MeViewController{

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
                self.greetingContainer.isHidden = true
                self.settingsButtonOutlet.customView?.isHidden = true
                self.greetingLabel.isHidden = true
                self.favouritesCollectionForMeViewController.isHidden = true
                self.ordersForMeViewController.isHidden = true
                self.showAllFavouritesViewOutlet.isHidden = true
                self.showAllOrdersOutlet.isHidden = true
                self.noInternetimageView.isHidden = false
                self.showAlertForInterNetConnection()
            }else{
                self.settingsButtonOutlet.customView?.isHidden = false
                self.greetingContainer.isHidden = false
                self.greetingLabel.isHidden = false
                self.favouritesCollectionForMeViewController.isHidden = false
                self.ordersForMeViewController.isHidden = false
                self.showAllFavouritesViewOutlet.isHidden = false
                self.showAllOrdersOutlet.isHidden = false
                self.noInternetimageView.isHidden = true

            }
        }
    }
}

