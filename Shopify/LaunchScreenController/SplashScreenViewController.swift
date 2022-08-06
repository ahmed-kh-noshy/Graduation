//
//  SplashScreenViewController.swift
//  Shopify
//
//  Created by Ibrahem's on 19/07/2022.
//

import UIKit

class SplashScreenViewController: UIViewController {

    @IBOutlet weak var splashScreenLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        splashScreenLabel.text = ""
        let titleText = "SHOPIFY"
        var charIndex = 0.0
        
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) {(timer) in
                self.splashScreenLabel.text?.append(letter)
            }
            charIndex += 1
        }
        

        DispatchQueue.main.asyncAfter(deadline: .now() +  2){
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
            homeVC.hidesBottomBarWhenPushed = false
            homeVC.modalPresentationStyle = .fullScreen
            homeVC.modalTransitionStyle = .flipHorizontal
          
            self.present(homeVC, animated: true) {
                UIView.animate(withDuration: 1.0, delay: 0.2, options: .autoreverse, animations: {
                    self.view.alpha = 0
                }, completion: nil)
            }
           
        }
    }
    
    
  

}
