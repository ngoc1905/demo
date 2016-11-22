//
//  DirectionsVC.swift
//  demo
//
//  Created by Ngoc Duong Phan on 11/20/16.
//  Copyright © 2016 Ngoc Duong Phan. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

protocol sendAdressDelegate {
    func sendAdress(origin: String?,destination: String?)
}

class DirectionsVC: UIViewController, UITextFieldDelegate {

    var sendDelegate : sendAdressDelegate?
    var bol = true
    
    @IBOutlet weak var originTextField: UITextField!
    
    @IBOutlet weak var destinationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originTextField.delegate = self
        destinationTextField.delegate = self
       

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
   
        if textField == originTextField {
        bol = true
        } else if textField == destinationTextField {
        bol = false
        }
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)

    }

    @IBAction func buttonSesrch(_ sender: AnyObject) {
        
        if let origin = originTextField.text, let destination = destinationTextField.text {
        sendDelegate?.sendAdress(origin: origin, destination: destination)
        }
        dismiss(animated: true, completion: nil)
    }
}
extension DirectionsVC : GMSAutocompleteViewControllerDelegate {
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        if bol == true {
             originTextField.text = place.formattedAddress
        } else {
        destinationTextField.text = place.formattedAddress
        }
   
        
        
        self.dismiss(animated: true, completion: nil)
           }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    
}
