//
//  BugVC.swift
//  demo
//
//  Created by Ngoc Duong Phan on 11/19/16.
//  Copyright © 2016 Ngoc Duong Phan. All rights reserved.
//

import UIKit

class BugVC: UIViewController {
    @IBOutlet weak var buttonMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cofigureUI()
        setupMenuButton()
//        setupLabelOnNavi()
    }
    func cofigureUI() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    func setupMenuButton(){
        buttonMenu.target = self.revealViewController()
        buttonMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
    }
    
    func setupLabelOnNavi(){
        if let navigationBAR = self.navigationController?.navigationBar {
        let frame =  CGRect(x: 0, y: 0, width: navigationBAR.frame.width/2, height: navigationBAR.frame.height)
         let label = UILabel(frame: frame)
            label.text = "muahaha"
            navigationBAR.addSubview(label)
        
        }
    }
}
