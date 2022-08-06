//
//  TabBarViewController.swift
//  BasicStructure
//
//  Created by Ibrahem's on 15/07/2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    let guestVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "guestNC")
    let profileVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "profileNC")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileVC.title = "My Profile"
        guestVC.title = "My Profile"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let checkUser = Helper.shared.getUserStatus()

        checkScreens(isLogged: checkUser)
        
        guard let items = self.tabBar.items else {return}
        
        

        let images = ["homekit","rectangle.3.group.fill","person.circle.fill"]

        for x in 0...2{
            items[x].image = UIImage(systemName: images[x])
        }
        
        let unselectedColor = UIColor.systemTeal ;
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .selected)
        tabBar.tintColor = .systemTeal
    }
    func checkScreens(isLogged:Bool){
        if isLogged {
            self.setViewControllers([profileVC], animated: true)

        }else{
            self.setViewControllers([guestVC], animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
