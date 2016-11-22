//
//  Test.swift
//  demo
//
//  Created by Ngoc Duong Phan on 11/21/16.
//  Copyright © 2016 Ngoc Duong Phan. All rights reserved.
//

import UIKit
import GoogleMaps

class Test: UIViewController, GMSMapViewDelegate , CLLocationManagerDelegate {
    
    
    var mapView: GMSMapView?
    let locationManaged = CLLocationManager()
    var currentCordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
//        let camera = GMSCameraPosition.camera(withLatitude:  (locationManaged.location?.coordinate.latitude)!, longitude:  (locationManaged.location?.coordinate.longitude)!, zoom: 14)
//        mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        
        locationManaged.delegate = self
        locationManaged.requestWhenInUseAuthorization()
        locationManaged.requestAlwaysAuthorization()
        mapView?.delegate = self
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
        locationManaged.startUpdatingLocation()
            mapView?.isMyLocationEnabled = true
            mapView?.settings.myLocationButton = true
        
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }

    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
//            currentCordinate = location.coordinate
//        mapView?.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15)
            mapView = GMSMapView.map(withFrame: .zero, camera: camera)
            view.addSubview(mapView!)
            view.addConstraintsWithFormat(format: "H:|[v0]|", views: mapView!)
            view.addConstraintsWithFormat(format: "V:|[v0]|", views: mapView!)
        locationManaged.stopUpdatingLocation()
        }
    }
}




//MARK: My location

//    func getMyLocation() {
//        locationManaged.delegate = self
//        locationManaged.requestWhenInUseAuthorization()
//        didFindMyLoction = true
//        mapView?.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
//
//    }
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if !didFindMyLoction {
//                        let myLocation: CLLocation = change![NSKeyValueChangeKey.newKey] as! CLLocation
//            mapView?.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 17)
//            didFindMyLoction = true
//
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == CLAuthorizationStatus.authorizedWhenInUse {
//            mapView?.isMyLocationEnabled = true
//        }
//    }
//    deinit {
//        if !didFindMyLoction {return}
//        mapView?.removeObserver(self, forKeyPath: "myLocation")
//
//    }
