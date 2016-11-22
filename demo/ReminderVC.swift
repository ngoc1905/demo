//
//  ReminderVC.swift
//  demo
//
//  Created by Ngoc Duong Phan on 11/19/16.
//  Copyright © 2016 Ngoc Duong Phan. All rights reserved.
//

import UIKit

class ReminderVC: UIViewController {
    

    
    let cellID = ["remind","day","repeat","priority"]
    
    @IBOutlet weak var tablView: UITableView!
    @IBOutlet weak var buttonMenu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupMenuButton()
    }
    
    func configureUI() {
        tablView.delegate = self
        tablView.dataSource = self
        tablView.tableFooterView = UIView(frame: .zero)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    func setupMenuButton(){
        buttonMenu.target = self.revealViewController()
        buttonMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
    }
    
    func getDate() -> String {
        let currentDay = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .full
        let convertedDay = dateFormat.string(from: currentDay)
        
        let hour = Calendar.current.component(.hour, from: Date())
        let minutes = Calendar.current.component(.minute, from: Date())
        return "\(convertedDay)                \(hour):\(minutes)"
    }
}

extension ReminderVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellID.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID[indexPath.row])
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "Remind me on A Day"
        case 1:
            cell?.textLabel?.text = getDate()
        case 2:
            cell?.textLabel?.text = "Repeat"
        case 3:
            cell?.textLabel?.text = "Priority"
        default:
            break
        }
        cell?.textLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = .zero
        cell?.layoutMargins = .zero
        return cell!
    }
    
    
}
