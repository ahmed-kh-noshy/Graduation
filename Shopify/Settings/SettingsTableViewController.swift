//
//  SettingsTableViewController.swift
//  BasicStructure
//
//  Created by Ibrahem's on 07/07/2022.
//

import UIKit

class SettingsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let cellSpacingHeight: CGFloat = 10
    var buttonIsAppear = false
    var currency = ""
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var settingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
      
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        loginButtonOutlet.layer.borderWidth = 0.5
        loginButtonOutlet.layer.cornerRadius = 10
        loginButtonOutlet.clipsToBounds = true
        
        
        if buttonIsAppear {
            loginButtonOutlet.isHidden = true
        }
        else {
            loginButtonOutlet.isHidden = false
        }
        
    }

    // MARK: - Table view data source
   
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
              return 1
    }
      func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return cellSpacingHeight
        }
        
        // Make the background color show through
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear
            return headerView
        }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath)

       // cell.textLabel?.text = "Test"

        switch (indexPath.section)
               {
               case 0:
                       cell.textLabel!.text = "Address"
                       cell.detailTextLabel?.text = "Mansourah"
               case 1:
                        cell.textLabel!.text = "Currency"
                         cell.detailTextLabel?.text = "USD"
         
               default:
                        cell.textLabel!.text = "About Us"
                        cell.detailTextLabel?.text = ""
               }
        
//             cell.layer.borderWidth = 0.5
//         cell.layer.cornerRadius = 10
//         cell.clipsToBounds = true
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section)
               {
               case 0:
            let chooseAddressViewController = storyboard?.instantiateViewController(withIdentifier: "ChooseAddressViewController") as! ChooseAddressViewController
            self.navigationController?.pushViewController(chooseAddressViewController, animated: true)
        
            
            
               case 1:
            let chooseCurrency = UIAlertController(title: "Choose Currency", message: "", preferredStyle: UIAlertController.Style.alert)
            
        
            chooseCurrency.addAction(UIAlertAction(title: "EGP", style: .default, handler: { (action: UIAlertAction!) in
                selectedCell?.detailTextLabel?.text = "EGP"
               
               }))
                    
            chooseCurrency.addAction(UIAlertAction(title: "USD", style: .cancel, handler: { (action: UIAlertAction!) in
                selectedCell?.detailTextLabel?.text = "USD"
                chooseCurrency .dismiss(animated: true, completion: nil)
               }))

                self.present(chooseCurrency, animated: true, completion: nil)
            
            
        case 2:
            let aboutUsViewController = storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
//            self.navigationController?.pushViewController(chooseAddressViewController, animated: true)
    
            self.present(aboutUsViewController, animated: true, completion: nil)
            
            
               default:
                        print("ERROR")
               }
       
        
    }
   
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 90
    }
    
    // Override to support conditional editing of the table view.
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
   
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        
        Manager.shared.setUserStatus(userIsLogged: false)
        Manager.shared.setUserID(customerID: 10)
        Manager.shared.setUserEmail(userEmail: "")
        Manager.shared.setUserName(userName: "")
        
      
        
                let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
}
