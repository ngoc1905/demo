//
//  CustomTabbarControllerViewController.swift
//  demo
//
//  Created by Ngoc Duong Phan on 11/22/16.
//  Copyright © 2016 Ngoc Duong Phan. All rights reserved.
//

import UIKit

class CustomTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let reminderVC = createNavController(viewcontroller: ReminderVC(), imageName: "Clock-50")
        let searchVC = createNavController(viewcontroller: SearchVC(), imageName: "Search-50")
        let shareVC = createNavController(viewcontroller: ShareVC(), imageName: "Share-50-2")
        
        viewControllers = [searchVC,reminderVC,shareVC]

    }
    
    func createNavController(viewcontroller: UIViewController,imageName: String?) -> UINavigationController {
    let viewcontroller = viewcontroller
        let nav = UINavigationController(rootViewController: viewcontroller)
        nav.tabBarItem.image = UIImage(named: "")
        return nav
    }


}
