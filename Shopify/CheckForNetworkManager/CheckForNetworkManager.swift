//
//  CheckForNetworkManager.swift
//  Shopify
//
//  Created by Ibrahem's on 19/07/2022.
//

import Foundation
import Reachability
class CheckForNetworkManager {
    
    static let sharedInstance = CheckForNetworkManager()
    var reachability: Reachability?
    func checkNetworkConnection(complition: @escaping (Bool)-> Void){
        reachability = try! Reachability()
        guard let reachability = reachability else {return}
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                complition(true)
            } else {
                print("Reachable via Cellular")
                complition(true)
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            complition(false)
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
//extension HomeViewController{
//    func createNoInterNetConnectImage(){
//        let image = UIImage(named: "network")
//        noInternetimageView = UIImageView(image: image!)
//        noInternetimageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
//        noInternetimageView.center = self.view.center
//        view.addSubview(noInternetimageView)
//    }
//}
//
//extension HomeViewController{
//    func checkNetworking(){
//        Helper.shared.checkNetworkConnectionUsingRechability { isConnected in
//            if !isConnected{
//                self.homeTableView.isHidden = true
//                self.noInternetimageView.isHidden = false
//                self.showAlertForInterNetConnection()
//            }else{
//                self.homeTableView.isHidden = false
//                self.noInternetimageView.isHidden = true
//                self.homeTableView.reloadData()
//            }
//        }
//    }
//}
