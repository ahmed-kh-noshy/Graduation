//
//  LoginViewController.swift
//  BasicStructure
//
//  Created by Tarek on 14/07/2022.
//

import UIKit


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var networkIndicator = UIActivityIndicatorView()
    var customes = [Customer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginViewModel = LoginViewModel(endpoint: "customers.json")
        loginViewModel.fetchData()
        loginViewModel.bindingData = { [weak self] customers , error in
            guard let self = self else {return}
            if let customers = customers {
                DispatchQueue.main.async {
                    self.customes = customers
                }
            }
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCustomers()
    }
    
    func showAlert(message : String){

            let alert = UIAlertController(title: "Some thing wronge", message: message , preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func loginAction(_ sender: Any) {
        print(customes)
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(message: "Complete all data first .")
            return
        }
        if let customer = customes.first(where: {$0.email == email && $0.tags == password}) {
            print("HELPPPPPP\(customer.id)")

           // Helper.shared.checkUserIsLogged(completion: true)
            Manager.shared.setUserStatus(userIsLogged: true)
            Manager.shared.setUserID(customerID: customer.id)
            Manager.shared.setUserEmail(userEmail: customer.email)
            Manager.shared.setUserName(userName: customer.first_name)
            let allAddresses = customer.addresses
            let addresses = allAddresses?.isEmpty
          
            if addresses! {
                Manager.shared.setFoundAdress(isFoundAddress: false)
                
            }
            else {
                Manager.shared.setFoundAdress(isFoundAddress: true)
            }
            
            
            
            print("loged in success")
            self.navigationController?.popToRootViewController(animated: true)
//            let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
//                tabBarController.selectedIndex = 0
//            self.presentingViewController?.dismiss(animated: true)
//            let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//
//               navigationController?.pushViewController(vc, animated: true)

        }else{
            showAlert(message: "No customer with this data .")
        }
        
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
           navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let signupViewController = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        signupViewController.customes = customes
        self.navigationController?.pushViewController(signupViewController, animated: true)
    }

}
extension LoginViewController {
    func getCustomers(){
        let loginViewModel = LoginViewModel(endpoint: "customers.json")
        loginViewModel.fetchData()
        loginViewModel.bindingData = { [weak self] customers , error in
            guard let self = self else {return}
            if let customers = customers {
                DispatchQueue.main.async {
                    self.customes = customers
                }
            }
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
    }
}
