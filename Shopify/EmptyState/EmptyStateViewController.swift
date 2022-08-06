//
//  EmptyStateViewController.swift
//  BasicStructure
//
//  Created by Ibrahem's on 05/07/2022.
//

import UIKit

class EmptyStateViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var emptyTitle: String = "" {
        didSet {
            titleLabel?.text = emptyTitle
        }
    }
    var emptyMessage: String = "" {
        didSet {
            messageLabel?.text = emptyMessage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel?.text = emptyTitle
        messageLabel?.text = emptyMessage
    }

}
