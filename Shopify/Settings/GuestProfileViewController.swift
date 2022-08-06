//
//  MyProfileViewController.swift
//  BasicStructure
//
//  Created by Ibrahem's on 15/07/2022.
//

import UIKit

class GuestProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func navigateToLogIn(_ sender: Any) {
     
        let loginScreen = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        self.navigationController?.pushViewController(loginScreen, animated: true)
       
    }
    
    @IBAction func navigateToRegister(_ sender: Any) {
    
        let signUpScreen = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        self.navigationController?.pushViewController(signUpScreen, animated: true)
    }
    

}
