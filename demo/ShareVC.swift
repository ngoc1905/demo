//
//  ShareVC.swift
//  demo
//
//  Created by Ngoc Duong Phan on 11/19/16.
//  Copyright © 2016 Ngoc Duong Phan. All rights reserved.
//

import UIKit
import SafariServices
class ShareVC: UIViewController {
    
    let cellID = "cell"
    var arrShare = ["Tumblr","Google+","Facebook","Twitter","More"]
    var urlShares = ["https://www.tumblr.com","https://plus.google.com","https://Facebook.com","https://twitter.com"]
    
    @IBOutlet weak var shareTableView: UITableView!
    @IBOutlet weak var buttonMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
         setupMenuButton()
    }
    
    func configureUI() {
        shareTableView.dataSource = self
        shareTableView.delegate = self
        shareTableView.tableFooterView = UIView(frame: .zero)
        shareTableView.separatorStyle = .none
//        shareTableView.alwaysBounceVertical = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    func setupMenuButton(){
        buttonMenu.target = self.revealViewController()
        buttonMenu.action = #selector(SWRevealViewController.revealToggle(_:))
    }
}
extension ShareVC : UITableViewDataSource , UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrShare.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = shareTableView.dequeueReusableCell(withIdentifier: cellID)
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = .zero
        cell?.layoutMargins = .zero
        cell?.textLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cell?.textLabel?.text = arrShare[indexPath.row]
        cell?.imageView?.image = UIImage(named: arrShare[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Share With :"
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            let activity = UIActivityViewController(activityItems: ["haha"], applicationActivities: nil)
            present(activity, animated: true, completion: nil)
        } else {
            if let url = URL(string: urlShares[indexPath.row]) {
                let safariController = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                present(safariController, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
        headerView.textLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    
    
}
