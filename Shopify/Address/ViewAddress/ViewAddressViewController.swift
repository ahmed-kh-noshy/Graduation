//
//  ViewAddressViewController.swift
//  BasicStructure
//
//  Created by Ibrahem's on 13/07/2022.
//

import UIKit
import CoreData

class ViewAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var phoneNumber = ""
    var customerName = ""
    var address = ""
    var city = ""
    var country = ""
  
    @IBOutlet weak var ViewAddressTableView: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ViewAddressTableView.delegate = self
        ViewAddressTableView.dataSource = self
        ViewAddressTableView.register(UINib(nibName: "ViewAddressTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: "ViewAddressTableViewCell")
        
      
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = ViewAddressTableView.dequeueReusableCell(withIdentifier: "ViewAddressTableViewCell", for: indexPath) as! ViewAddressTableViewCell
     
        cell.countryLabel.text = country
        cell.phoneLabel.text = phoneNumber
        cell.address1Label.text = address
        cell.nameLabel.text = customerName
             return cell
         }
    }
    


