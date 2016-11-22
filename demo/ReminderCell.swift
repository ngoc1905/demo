//
//  ReminderCell.swift
//  demo
//
//  Created by Ngoc Duong Phan on 11/21/16.
//  Copyright © 2016 Ngoc Duong Phan. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {
    
    
    
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var priorityLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
