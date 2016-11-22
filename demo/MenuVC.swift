//
//  MenuVC.swift
//  demo
//
//  Created by Ngoc Duong Phan on 11/18/16.
//  Copyright © 2016 Ngoc Duong Phan. All rights reserved.
//

import UIKit




class MenuVC: UIViewController, UITableViewDataSource , UITableViewDelegate{
    
    
    var arrMenu = ["Home","Search","Clock","Share","Bug","Notification","Exit"]
    var arrIconMenu = ["home","search","clock","share","bug","notification","exit"]
    
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    func configureUI() {
        view.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        bottomView.backgroundColor = UIColor.rgb(red: 200,green: 30.6,blue: 31.62)
        
        
        
    }
    
    //MARK : TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuItem = arrMenu[indexPath.row]
        let imageNameItem = arrIconMenu[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: menuItem) as! MenuCell
        cell.configureCell(cell: cell, menuItem: menuItem, nameImageItem: imageNameItem)
//        let selectionView = UIView()
//        selectionView.backgroundColor = UIColor.rgb(red: 200,green: 30.6,blue: 31.62)
//        UITableViewCell.appearance().selectedBackgroundView = selectionView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 6 {
            self.revealViewController().revealToggle(animated: true)
        }
    }
}


class MenuCell: UITableViewCell {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    
//    override var isHighlighted:  Bool {
//        didSet {
//            backgroundColor = isHighlighted ? UIColor.rgb(red: 200,green: 30.6,blue: 31.62) : UIColor.white
//            
//            self.textLabel?.textColor = isHighlighted ? UIColor.white : UIColor.black
//            
//            self.imageView?.tintColor = isHighlighted ? UIColor.white : UIColor.darkGray
//        }
//    }
    
    func configureCell(cell : UITableViewCell,menuItem : String,nameImageItem: String){
    cell.textLabel?.text = menuItem
    cell.imageView?.image = UIImage(named: nameImageItem)
    cell.separatorInset = .zero
    cell.layoutMargins = .zero
        cell.textLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
}
