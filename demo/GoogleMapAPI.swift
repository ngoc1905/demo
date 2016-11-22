//
//  googleMapAPI.swift
//  demo
//
//  Created by Ngoc Duong Phan on 11/20/16.
//  Copyright © 2016 Ngoc Duong Phan. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapAPI: NSObject {
    
    //MARK: Find Location
    var baseURLFindAdress = "https://maps.googleapis.com/maps/api/geocode/json?"
    var formattedAdressFind : String!
    var latitudeAdressFind: Double!
    var longtitudeAdressFind: Double!
    var findAddressResult: Dictionary<String,Any>!
    
    //MARK: Directions
    let baseUrlDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    var routes: Dictionary<String,Any>!
    var polyline: Dictionary<String,Any>!
    var originCordinate : CLLocationCoordinate2D!
    var destinationCordinate: CLLocationCoordinate2D!
    var originAdress :String!
    var destinationAdress: String!
    
    //MARK: Distance , Duration
    var totalDistanceInMeters: UInt = 0
    var totalDistance : String?
    var totalDurationInSecond: UInt = 0
    var totalDuration : String?
    
    
    //MARK: Method Find Adress
    func fetchedAdress(adress: String,completion: @escaping ((_ status: String,_ success: Bool) -> Void)) {
        let findAdress: String = adress
        var urlFindAdressString = baseURLFindAdress + "address=" + findAdress
        urlFindAdressString = urlFindAdressString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlFindAdress = URL(string: urlFindAdressString)
        let urlRequest = URLRequest(url: urlFindAdress!)
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { (data, respone, error) in
            DispatchQueue.main.async {
                do {
                    let dictionnary: Dictionary<String,Any> = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! Dictionary<String,Any>
                    let status = dictionnary["status"] as! String
                    if status == "OK" {
                        let allResult = dictionnary["results"] as! [Dictionary<String,Any>]
                        self.findAddressResult = allResult[0]
                        
                        self.formattedAdressFind = self.findAddressResult["formatted_address"] as! String
                        let geomery = self.findAddressResult["geometry"] as! Dictionary<String,Any>
                        self.longtitudeAdressFind = ((geomery["location"] as! Dictionary<String,Any>)["lng"] as! NSNumber).doubleValue
                        self.latitudeAdressFind = ((geomery["location"] as! Dictionary<String,Any>)["lat"] as! NSNumber).doubleValue
                        completion(status, true)
                    } else {
                        completion(status, false)
                    }
                } catch {
                    print(error)
                    completion("",false)
                }
            }
            }.resume()
    }
    
    
    //MARK: Method Directions
    func fetchedDirections(origin: String?,destination: String?,completion: @escaping (_ status:String,_ success:Bool) -> Void) {
        if let originLocation: String = origin {
            if let destinationLocation:String = destination{
                var directionUrlString = baseUrlDirections + "origin=" + originLocation + "&destination=" + destinationLocation
                directionUrlString = directionUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let directionURL = URL(string: directionUrlString)
                let urlRequest = URLRequest(url: directionURL!)
                let session = URLSession.shared
                session.dataTask(with: urlRequest, completionHandler: { (data, respone, error) in
                    DispatchQueue.main.async {
                        do {
                            let dictionnary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? Dictionary<String,Any>
                            let status = dictionnary?["status"] as! String
                            if status == "OK" {
                                self.routes = (dictionnary?["routes"] as! [Dictionary<String,Any>])[0]
                                self.polyline = self.routes?["overview_polyline"] as? Dictionary<String,Any>
                                let legs = self.routes["legs"] as? [Dictionary<String,Any>]
                                let startLocation = legs?[0]["start_location"] as? Dictionary<String,Any>
                                self.originCordinate = CLLocationCoordinate2D(latitude: (startLocation!["lat"] as! NSNumber).doubleValue, longitude: (startLocation!["lng"] as! NSNumber).doubleValue)
                                self.originAdress = legs?[0]["start_address"] as? String
                                
                                let endLocation = legs?[0]["end_location"] as? Dictionary<String,Any>
                                self.destinationCordinate = CLLocationCoordinate2D(latitude: ((endLocation?["lat"] as? NSNumber)?.doubleValue)!, longitude: (endLocation?["lng"] as! NSNumber).doubleValue)
                                self.destinationAdress = legs?[0]["end_address"] as? String
                                self.calculateTotalDistanceAndDuration()
                                completion(status, true)
                            }
                        } catch {
                            print(error)
                            completion("", false)
                        } }
                }).resume()
            } else{
                completion("Destination nil",false)
            }
        } else {
            completion("Origin nil",false)
        }
        
    }
    
    //MARK: cacluate Distance and Duration
    func calculateTotalDistanceAndDuration() {
        let legs = self.routes["legs"] as! Array<Dictionary<String, AnyObject>>
        
        totalDistanceInMeters = 0
        totalDurationInSecond = 0
        
        for leg in legs {
            totalDistanceInMeters += (leg["distance"] as! Dictionary<String,Any>)["value"] as! UInt
            totalDurationInSecond += (leg["duration"] as! Dictionary<String, Any>)["value"] as! UInt
        }
        
        
        let distanceInKilometers: Double = Double(totalDistanceInMeters / 1000)
        totalDistance = "Total Distance: \(distanceInKilometers) Km"
        
        
        let mins = totalDurationInSecond / 60
        let hours = mins / 60
        let days = hours / 24
        let remainingHours = hours % 24
        let remainingMins = mins % 60
        
        
        totalDuration = "Duration: \(days) d, \(remainingHours) h, \(remainingMins) mins"
    }
}





