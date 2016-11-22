//
//  ViewController.swift
//  demo
//
//  Created by Ngoc Duong Phan on 11/17/16.
//  Copyright © 2016 Ngoc Duong Phan. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class SearchVC: UIViewController, UISearchBarDelegate , CLLocationManagerDelegate, GMSMapViewDelegate  , UITabBarDelegate , sendAdressDelegate  {
    
    var mapTasks = GoogleMapAPI()
    
    
    var locationMarker = GMSMarker()
    
    var locationManaged = CLLocationManager()
    var didFindMyLoction = false
    
    @IBOutlet weak var buttonMenu: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    var mapView : GMSMapView?
    
    
    //MARK: draw directios
    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    var routePolyline: GMSPolyline!
    
    
    func sendAdress(origin: String?, destination: String?) {
        self.mapTasks.fetchedDirections(origin: origin, destination: destination, completion: { (status, succes) in
            if succes {
                self.setupMapview()
                self.configureMapAndDirections()
                self.drawDirctions()
                self.mapView?.reloadInputViews()
            } else {
                print("UMOMO: \(status)")
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didFindMyLoction = false
        searchBar.delegate = self
        setupBarBackgroundView()
        setupMapview()
        managedLocation()
        setupSideBar()
        configureUI()
//        getMyLocation()
        print("UMOMO \(mapTasks.destinationCordinate)")
        

        
        
    }
    
    
    @IBAction func buttonDirections(_ sender: AnyObject) {
        //        directions()
        if let vcDirect = storyboard?.instantiateViewController(withIdentifier: "directionsVC") as? DirectionsVC {
            self.present(vcDirect, animated: true, completion: nil)
            vcDirect.sendDelegate = self
        }
    }
    
    
    func configureUI() {
        navigationController?.navigationBar.isTranslucent = false
        tabBarController?.tabBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.rgb(red: 200,green: 30.6,blue: 31.62)
        searchBar.tintColor = .white
        searchBar.text = ""
    }
    
    //MARK: SideBar
    func setupSideBar() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        buttonMenu.target = self.revealViewController()
        buttonMenu.action = #selector(SWRevealViewController.revealToggle(_:))
    }
    
    //MARK: Mapview
    

    
    func setupMapview() {
        let camera = GMSCameraPosition.camera(withLatitude: 16.060688, longitude: 108.184518, zoom: 3)
        mapView?.delegate = self
        mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView?.settings.compassButton = true
        mapView?.settings.myLocationButton = true
        mapView?.settings.indoorPicker = true
        view.addSubview(mapView!)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: mapView!)
        view.addConstraintsWithFormat(format: "V:[v0][v1]|", views: searchBar,mapView!)
    }
    
    func setupBarBackgroundView(){
        if let window = UIApplication.shared.keyWindow {
            let backgroundBarView = UIView()
            backgroundBarView.backgroundColor = UIColor.rgb(red: 180, green: 31, blue: 31)
            backgroundBarView.translatesAutoresizingMaskIntoConstraints = false
            window.addSubview(backgroundBarView)
            window.addConstraintsWithFormat(format: "H:|[v0]|", views: backgroundBarView);
            window.addConstraintsWithFormat(format: "V:|[v0(20)]", views: backgroundBarView);
        }
    }
    
    //MARK: Current location
    
    func managedLocation(){
    locationManaged.delegate = self
    locationManaged.requestWhenInUseAuthorization()
        locationManaged.requestAlwaysAuthorization()
           }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManaged.startUpdatingLocation()
            mapView?.isMyLocationEnabled = true
            mapView?.settings.myLocationButton = true
            mapView?.isTrafficEnabled = true
            mapView?.isBuildingsEnabled = true
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView?.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)

                        locationManaged.stopUpdatingLocation()
        }
    }
    
    

    //MARK: Search Bar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.8) {
            searchBar.text = ""
            self.searchBar.showsCancelButton = false
            searchBar.resignFirstResponder()
        }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        findAdress()
    }
    func findAdress() {
        self.mapTasks.fetchedAdress(adress: searchBar.text!) { (status, sucess) in
            if !sucess {
                print(status)
                if status == "ZERO_RESULTS" {
                    self.showAlertWithMessage(message: "Adress not found")
                }
            } else {
                self.setupMapview()
                let latitude = self.mapTasks.latitudeAdressFind
                let longtitude = self.mapTasks.longtitudeAdressFind
                let cordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longtitude!)
                self.mapView?.camera = GMSCameraPosition.camera(withTarget: cordinate, zoom: 12)
                self.setupLocationMarker(cordinate: cordinate)
            }
        }
        UIView.animate(withDuration: 1.2) {
            self.searchBar.resignFirstResponder()
        }
        
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
//        UIView.animate(withDuration: 1.2) {
//            self.searchBar.showsCancelButton = true
//            
//        }
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    
    //MARK: Marker location
    func setupLocationMarker(cordinate: CLLocationCoordinate2D) {
        locationMarker = GMSMarker(position: cordinate)
        locationMarker.map = mapView
        locationMarker.title = mapTasks.formattedAdressFind
        locationMarker.appearAnimation = kGMSMarkerAnimationPop
        locationMarker.icon = GMSMarker.markerImage(with:#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))
        locationMarker.opacity = 0.75
        
        locationMarker.isFlat = true
        locationMarker.snippet = "Best Location"
    }
    
    func showAlertWithMessage(message: String) {
        
        let alert = UIAlertController(title: "WoOpps", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Canel", style: .cancel, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func directions(){
        let alert = UIAlertController(title: "Directions now", message: "🚲 🚗 ✈️ 🚅", preferredStyle: .alert)
        alert.view.tintColor = UIColor.rgb(red: 200,green: 30.6,blue: 31.62)
        alert.view.backgroundColor = .gray
        alert.addTextField { (textField) in
            textField.placeholder = "Origin Adress "
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Destination Adress "
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let directions = UIAlertAction(title: "Direction", style: .default) { (action) in
            let origin = (alert.textFields?[0].text)! as String
            let destination = (alert.textFields?[1].text)!  as String
            self.mapTasks.fetchedDirections(origin: origin, destination: destination, completion: { (status, succes) in
                if succes {
                    self.setupMapview()
                    self.configureMapAndDirections()
                    self.drawDirctions()
                } else {
                    print("UMOMO: \(status)")
                }
            })
        }
        
        alert.addAction(cancel)
        alert.addAction(directions)
        UIView.animate(withDuration: 1.2) {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func configureMapAndDirections() {
        mapView?.camera = GMSCameraPosition.camera(withTarget: self.mapTasks.originCordinate, zoom: 14)
        
        originMarker = GMSMarker(position: self.mapTasks.originCordinate)
        originMarker.map = self.mapView
        originMarker.icon = GMSMarker.markerImage(with: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
        originMarker.title = self.mapTasks.originAdress
        
        destinationMarker = GMSMarker(position: self.mapTasks.destinationCordinate)
        destinationMarker.map = self.mapView
        destinationMarker.icon = GMSMarker.markerImage(with: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
        destinationMarker.title = self.mapTasks.destinationAdress
        
    }
    
    func drawDirctions() {
        let route = mapTasks.polyline["points"] as! String
        
        let path = GMSPath(fromEncodedPath: route)
        routePolyline = GMSPolyline(path: path)
       
               routePolyline.map = mapView
    }
    
    
}
 //MARK: Autocomplete google places
extension SearchVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        searchBar.text = place.formattedAddress
        findAdress()
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







