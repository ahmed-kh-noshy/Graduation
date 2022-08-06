//
//  SignUpViewController.swift
//  BasicStructure
//
//  Created by n0shy on 14/07/2022.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var firstNameContainerView: UIView!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var lastNameContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordContainerView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    
    var networkIndicator = UIActivityIndicatorView()
    var customes = [Customer]()
    var registerViewModel = SignUpViewModel( endpoint: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text else { return }
        print("PRESSED")
        if checkInfoBeforeRegister() {
            register()
        }
       
        let loginScreen = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    
            self.navigationController?.pushViewController(loginScreen, animated: true)

  
        
    }
    
    func register(){
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let email = emailTextField.text,
              let password = passwordTextField.text else {return}
        let customer = Customer(first_name: firstName, last_name: lastName, email: email, phone: nil, tags: password, id: nil, verified_email: true, addresses: nil)
        let newCustomer = NewCustomer(customer: customer)
       
        if checkUserIsExist(email: email) {
            //user found
        }else{
            let signUpViewModel = SignUpViewModel(endpoint: "customers.json")
            signUpViewModel.createNewCustomer(newCustomer: newCustomer) { data, response, error in
                
                guard error == nil else {
                    //register is not success
                    print("error")
                    return
                }
                
                
                guard let data = data else {
                    return
                }
                
                print(data)
                
            }
                print("register is success")
            }
//        DispatchQueue.main.async {
//
//
//        }
        }
    }


extension SignUpViewController {
    
    func checkUserIsExist(email: String) -> Bool {
        guard let customer = customes.first(where: {$0.email ==  email}) else { return false}
        return true
    }
    
    func showAlert(message : String){
        
        let alert = UIAlertController(title: "Some thing wronge", message: message , preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func checkInfoBeforeRegister()->Bool{
        var checkIsSuccess = true
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let email = emailTextField.text,
              let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text else {return false}
        
        
        self.registerViewModel.checkCustomerInfo(firstName: firstName, lastName: lastName, email: email, password: password, confirmPassword: confirmPassword) { message in
            
            switch message {
            case "ErrorAllInfoIsNotFound":
                checkIsSuccess = false
                self.showAlert(message: "for register must fill all information")
            case "ErrorPassword":
                checkIsSuccess = false
                self.showAlert(message: "please enter password again")
            case "ErrorEmail":
                checkIsSuccess = false
                self.showAlert(message: "please enter correct email")
            default:
                checkIsSuccess = true
            }
        }
        return checkIsSuccess
    }
    
}
