//
//  NotificationVC.swift
//  demo
//
//  Created by Ngoc Duong Phan on 11/19/16.
//  Copyright © 2016 Ngoc Duong Phan. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    
    @IBOutlet weak var buttonMenu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        buttonMenu.target = self.revealViewController()
        buttonMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
    }
    
}
