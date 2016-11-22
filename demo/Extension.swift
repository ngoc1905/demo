//
//  Extension.swift
//  demo
//
//  Created by Ngoc Duong Phan on 11/17/16.
//  Copyright © 2016 Ngoc Duong Phan. All rights reserved.
//

import UIKit
extension UIView {
    
    func addConstraintsWithFormat(format: String,views: UIView...) {
        var viewDic = [String : UIView]()
        
        for (index,view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false //warning
            viewDic[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDic))
    }
}
extension UIColor {
    
    static func rgb(red: CGFloat,green: CGFloat,blue: CGFloat) -> UIColor {
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}
