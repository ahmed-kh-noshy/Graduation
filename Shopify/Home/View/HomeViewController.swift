//
//  ViewController.swift
//  BasicStructure
//
//  Created by Noshy on 04/07/2022.
//

import UIKit

class HomeViewController: UIViewController {
    var noInternetimageView = UIImageView()
    var networkIndicator = UIActivityIndicatorView()
    var timer:Timer?
    var currentIndex = 0
    var brand = [SmartCollection]()


    var arrayOfAds = [UIImage(named: "bigsale")!,UIImage(named: "offer1")!,UIImage(named: "supersale")!]

    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var adsCollectionView: UICollectionView!
    @IBOutlet weak var homeViewCollectionView: UICollectionView!

    //MARK: - check For Login



    override func viewDidLoad() {
        super.viewDidLoad()
 
//        createNoInterNetConnectImage()
        addActivityIndicator()

        let homeViewModel = HomeViewModel(endpoint: "smart_collections.json")
            homeViewModel.fetchData()
            homeViewModel.bindingData = {brands , error in

                if let brands = brands {
                    self.brand = brands
                    DispatchQueue.main.async {
                        self.homeViewCollectionView.reloadData()
                        self.networkIndicator.stopAnimating()


                    }
                }
                if let error = error {
                    print(error.localizedDescription)
                }

            }

        setUpUi()
        startTimer()


    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


//        self.checkNetworking()
    }

    func setUpUi(){
        homeViewCollectionView.dataSource = self
        homeViewCollectionView.delegate   = self



        adsCollectionView.delegate = self
        adsCollectionView.dataSource  = self
        adsCollectionView.layer.cornerRadius = 10
        adsCollectionView.clipsToBounds = true
        adsCollectionView.layer.masksToBounds = true
        adsCollectionView.layer.borderWidth = 1


        pageController.numberOfPages = arrayOfAds.count
        adsCollectionView.reloadData()

    }
    func addActivityIndicator(){
        networkIndicator.style = .medium
        networkIndicator.center = homeViewCollectionView.center
        networkIndicator.startAnimating()
        view.addSubview(networkIndicator)
    }
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
    }

    @objc func moveToNextIndex() {

        if currentIndex < arrayOfAds.count - 1 {
            currentIndex += 1
        }else{
            currentIndex = 0
        }

        adsCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageController.currentPage = currentIndex
    }

  

    @IBAction func searchAllProducts(_ sender: UIBarButtonItem) {
        if let productsVC = storyboard?.instantiateViewController(withIdentifier: "ProductSearchViewController") as? ProductSearchViewController {



            self.navigationController?.pushViewController(productsVC , animated: true)
        }

    }
}

extension HomeViewController: UICollectionViewDataSource {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfItems = 0

        if collectionView == homeViewCollectionView {
            numberOfItems = brand
                .count
        }else if collectionView == adsCollectionView {
            numberOfItems = arrayOfAds.count
        }

        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if (collectionView == homeViewCollectionView)
        {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeViewCollectionViewCell", for: indexPath) as! HomeViewCollectionViewCell

        cell.configureCell(with: brand[indexPath.row])



       cell.brandName.text = brand[indexPath.row].title


        return cell
        }
        else if (collectionView == adsCollectionView)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adsCollectionViewCell", for: indexPath) as! adsCollectionViewCell

            cell.adsImage.image = arrayOfAds[indexPath.row]

            return cell

        }

        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == adsCollectionView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)


        }
        return CGSize()
    }

}

extension HomeViewController: UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == homeViewCollectionView) {
        if let productsVC = storyboard?.instantiateViewController(withIdentifier: "SeeAllBrandsViewController") as? SeeAllBrandsViewController {

            productsVC.brandName = brand[indexPath.row].title

            self.navigationController?.pushViewController(productsVC , animated: true)
        }
        }

        else if (collectionView == adsCollectionView)
        {


            let alert = UIAlertController(title: "Discount !!", message: "Copy Your Discount Coupon To Use It In Checkout", preferredStyle: .alert)

            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                let couponArray = ["SUMMERDiscount10%","20%Discount","15%ForThisItem"]
                for i in 0..<couponArray.count {
                    let coupon = couponArray[i]
                    textField.text = coupon
                }

            }

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields!

            }))


            self.present(alert, animated: true, completion: nil)


        }
        }



    }




extension String {

      func stringToImage(_ handler: @escaping ((UIImage?)->())) {
          if let url = URL(string: self) {
              URLSession.shared.dataTask(with: url) { (data, response, error) in
                  if let data = data {
                      let image = UIImage(data: data)
                      handler(image)
                  }
              }.resume()
          }
      }
  }

//MARK: - Check for Connection in HomeViewController

extension HomeViewController{

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
                self.homeViewCollectionView.isHidden = true
                self.adsCollectionView.isHidden = true

                self.pageController.isHidden = true
                self.searchButton.customView?.isHidden = true
                self.noInternetimageView.isHidden = false
                self.showAlertForInterNetConnection()
            }else{
                self.homeViewCollectionView.isHidden = false
                self.noInternetimageView.isHidden = true

                self.adsCollectionView.isHidden = false
                self.pageController.isHidden = false
                self.searchButton.customView?.isHidden = false
                self.homeViewCollectionView.reloadData()
            }
        }
    }
}
