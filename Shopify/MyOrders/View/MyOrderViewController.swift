//
//  MyOrderViewController.swift
//  BasicStructure
//
//  Created by Noshy on 05/07/2022.
//

import UIKit

class MyOrderViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView: UIView!
    
    
    var orderArray: [Order] = []
    let myOrdersViewmodel = MyOrdersViewModel()
    let networking = NetworkManger()
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        myOrdersViewmodel.bindSuccessToView = {
            self.onMyOrdersSucces()
        }
        
        myOrdersViewmodel.bindFailedToView = {
            self.onFailure()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupTableView()
    }
    func onMyOrdersSucces(){
        self.orderArray = myOrdersViewmodel.orders
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    func onFailure(){
        let alert = UIAlertController(title: "Error", message: myOrdersViewmodel.showError, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MyOrderTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: "MyOrderTableViewCell")
    }
    
   
    

}
extension MyOrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderTableViewCell", for: indexPath) as! MyOrderTableViewCell
        cell.dateLabel.text = orderArray[indexPath.row].created_at
        cell.priceLabel.text = "Paid " + orderArray[indexPath.row].current_total_price! + " USD"
        cell.orderIDLabel.text = "Order ID: \(orderArray[indexPath.row].id!)"
        
        
    
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: false)
       
//       let myordersVC = self.storyboard?.instantiateViewController(withIdentifier: "MyOrdersDetailsTableViewController") as! MyOrdersDetailsTableViewController
//       myordersVC.comingOrder = ordersArray[indexPath.row].line_items!
//       self.present(myordersVC, animated: true)
   }
    
}
   




