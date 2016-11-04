//
//  LocationManager.swift
//  MyBus
//
//  Created by Sebastian Fink on 11/1/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import MapKit


//LocationManagerDelegate protocol
@objc protocol LocationManagerDelegate:NSObjectProtocol {
    func locationFound(latitude:Double, longitude:Double) -> Void
    optional func locationManagerReceivedError(error:String, localizedDescription:String)
}

typealias CLReverseGeocodeCompletionHandler = (street:String?, houseNumber:String?, locality:String?, error:String?) -> ()
typealias GoogleReverseGeocodeCompletionHandler = () -> ()



private let _sharedInstance = LocationManager()

class LocationManager:NSObject, CLLocationManagerDelegate {
    
    let verboseMessageDictionary = [CLAuthorizationStatus.NotDetermined:"Aun no ha determinado los permisos de geolocalización de esta aplicación.",
                                    CLAuthorizationStatus.Restricted:"Esta aplicación no esta autorizada a utilizar servicios de geolocalización.",
                                    CLAuthorizationStatus.Denied:"You have explicitly denied authorization for this application, or location services are disabled in Settings.",
                                    CLAuthorizationStatus.AuthorizedAlways:"La aplicación esta autorizada a utilizar servicios de ubicación.",
                                    CLAuthorizationStatus.AuthorizedWhenInUse:"Ud ha permitido el uso de su ubicación solo cuando la aplicación esté siendo utilizada."]

    
    
    
    private var coreLocationManager:CLLocationManager!
    
    var lastKnownLocation:CLLocation?
    var locationDelegate:LocationManagerDelegate?
    
    
    // MARK: - Instantiation
    class var sharedInstance: LocationManager {
        return _sharedInstance
    }
    
    private override init() {
        super.init()
    }
    
    private func startLocationManager(){
        coreLocationManager = CLLocationManager()
        coreLocationManager.delegate = self
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            startUpdating()
        }
        
    }
    
    func startUpdating(){
        coreLocationManager.startUpdatingLocation()
    }
    
    func stopUpdating(){
        coreLocationManager.stopUpdatingLocation()
    }
    
    
    func isLocationAuthorized() -> Bool {
        let locationServiceAuth = CLLocationManager.authorizationStatus()
        if(locationServiceAuth == .AuthorizedAlways || locationServiceAuth == .AuthorizedWhenInUse) {
            return true
        }
        return false
    }
    
    
    private func resetLocation(){
        self.lastKnownLocation = nil
    }
    
    // MARK: CLLocationManagerDelegate protocol methods
    internal func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let bestLocation:CLLocation = locations.last else {
            return
        }
        
        self.lastKnownLocation = bestLocation
        
        if let delegate = locationDelegate {
            delegate.locationFound(bestLocation.coordinate.latitude, longitude: bestLocation.coordinate.longitude)
        }
        
        
    }
    
    internal func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        
        stopUpdating()
        resetLocation()
        
        //send a nsnotification
    }
    
    
    
    // MARK: Apple Reverse Geocoding
    func CLReverseGeocoding(latitude:Double, longitude:Double, handler:CLReverseGeocodeCompletionHandler){
        
        let location:CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            
            if let err = error {
                return handler(street: nil, houseNumber: nil, locality: nil, error: err.localizedDescription)
            }
           
            
            
            
        }
        
        /*
         
         CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) {
         placemarks, error in
         guard let placemark = placemarks?.first, let locality = placemark.locality where validLocalities.contains(locality.lowercaseString) else {
         return completionHandler(nil, error)
         }
         
         let point = RoutePoint()
         point.latitude = latitude
         point.longitude = longitude
         if let street = placemark.thoroughfare, let houseNumber = placemark.subThoroughfare {
         let streetName = (street as String).stringByReplacingOccurrencesOfString("Calle ", withString: "")
         let house = (houseNumber as String).componentsSeparatedByString("–").first! ?? ""
         let address = "\(streetName) \(house)"
         point.address = address
         } else {
         point.address = locality
         }
         completionHandler(point, nil)
         }
         
         
         */
        
        
        
    }
    
    // MARK: Google Reverse Geocoding
    func googleReverseGeocoding(location:(latitude:Double,longitude:Double)){
    }
    
    
    
    
    
    
    
    
    
}