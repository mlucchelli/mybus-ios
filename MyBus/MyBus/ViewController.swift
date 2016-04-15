//
//  ViewController.swift
//  MyBus
//
//  Created by Marcos Vivar on 4/12/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit
import Mapbox

class ViewController: UIViewController, MGLMapViewDelegate {

    
    @IBOutlet var plusButtonView: UIView!
    @IBOutlet var minusButtonView: UIView!
    @IBOutlet var compassButtonView: UIView!
    
    @IBOutlet var mapView : MGLMapView!
    let minZoomLevel : Double = 9
    let maxZoomLevel : Double = 16

    override func viewDidLoad()
    {
        super.viewDidLoad()
        plusButtonView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
        plusButtonView.layer.cornerRadius = 20
        let plusButtonTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.plusButtonTap(_:)))
        plusButtonView.userInteractionEnabled = true
        plusButtonView.addGestureRecognizer(plusButtonTap)
        
        minusButtonView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
        minusButtonView.layer.cornerRadius = 20
        let minusButtonTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.minusButtonTap(_:)))
        minusButtonView.userInteractionEnabled = true
        minusButtonView.addGestureRecognizer(minusButtonTap)
        
        compassButtonView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
        compassButtonView.layer.cornerRadius = 20
        let compassButtonTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.compassButtonTap(_:)))
        compassButtonView.userInteractionEnabled = true
        compassButtonView.addGestureRecognizer(compassButtonTap)
        
        mapView.maximumZoomLevel = maxZoomLevel
        mapView.minimumZoomLevel = minZoomLevel
        mapView.userTrackingMode = .Follow
        mapView.delegate = self
        
        // Setup offline pack notification handlers.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.offlinePackProgressDidChange(_:)), name: MGLOfflinePackProgressChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.offlinePackDidReceiveError(_:)), name: MGLOfflinePackProgressChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.offlinePackDidReceiveMaximumAllowedMapboxTiles(_:)), name: MGLOfflinePackProgressChangedNotification, object: nil)

        // Double tapping zooms the map, so ensure that can still happen
        let doubleTap = UITapGestureRecognizer(target: self, action: nil)
        doubleTap.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(doubleTap)
        
        // Delay single tap recognition until it is clearly not a double
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleSingleTap(_:)))
        singleTap.requireGestureRecognizerToFail(doubleTap)
        mapView.addGestureRecognizer(singleTap)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func handleSingleTap(tap: UITapGestureRecognizer) {
        // Convert tap location (CGPoint) to geographic coordinates (CLLocationCoordinate2D)
        let tappedLocation: CLLocationCoordinate2D = mapView.convertPoint(tap.locationInView(mapView), toCoordinateFromView: mapView)
        
        // Remove first marker tapped from the map, add marker with coordinates
        // Prevent having more than two points selected in map
        if (mapView.annotations?.count != nil && mapView.annotations?.count > 1 ) {
            mapView.removeAnnotation(mapView.annotations![0])
        }
        
        Connectivity.sharedInstance.getAddressFromCoordinate(tappedLocation.latitude, longitude: tappedLocation.longitude) { responseObject, error in
            let address = "\(responseObject!["calle"] as! String) \(responseObject!["altura"] as! String)"
            
            // Declare the marker point and set its coordinates
            let mapPoint = MGLPointAnnotation()
            mapPoint.coordinate = CLLocationCoordinate2D(latitude: tappedLocation.latitude, longitude: tappedLocation.longitude)
            mapPoint.title = address
            
            // Add marker to the map
            self.mapView.addAnnotation(mapPoint)
            
            // Pop-up the callout view
            self.mapView.selectAnnotation(mapPoint, animated: true)
        }

<<<<<<< 6b7d98c2cf9429fc6fddedb22cd93b3a72b07e72
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool{
        return true
    }
    
    override func didReceiveMemoryWarning() {
=======
    override func didReceiveMemoryWarning()
    {
>>>>>>> MYB-51 Added SearchViewController and updated storyboard.
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MGLMapView, didUpdateUserLocation userLocation: MGLUserLocation?) {
        mapView.centerCoordinate = (userLocation!.location?.coordinate)!
    }
    
    func mapViewDidFinishLoadingMap(mapView: MGLMapView) {
        if MGLOfflineStorage.sharedOfflineStorage().packs?.count == 0 {
            startOfflinePackDownload()
        }
    }
    
    func startOfflinePackDownload() {
        let region = MGLTilePyramidOfflineRegion(styleURL: mapView.styleURL, bounds: mapView.visibleCoordinateBounds, fromZoomLevel: minZoomLevel, toZoomLevel: maxZoomLevel)
        let userInfo = ["name": "OfflineMap"]
        let context = NSKeyedArchiver.archivedDataWithRootObject(userInfo)
        
        MGLOfflineStorage.sharedOfflineStorage().addPackForRegion(region, withContext: context) { (pack, error) in
            guard error == nil else {
                print("Error: \(error?.localizedFailureReason)")
                return
            }
            pack!.resume()
        }
    }
    
    
    // MARK: - BUTTON HANDLERS
    
    func plusButtonTap(sender: UITapGestureRecognizer){
        mapView.setZoomLevel(mapView.zoomLevel+1, animated: true)
    }
    
    func minusButtonTap(sender: UITapGestureRecognizer){
        mapView.setZoomLevel(mapView.zoomLevel-1, animated: true)
    }
    
    func compassButtonTap(sender: UITapGestureRecognizer){
        if let userLocation = mapView.userLocation {
            mapView.setCenterCoordinate(userLocation.coordinate, animated: true)
        }
    }
    
    // MARK: - MGLOfflinePack notification handlers
    
    func offlinePackProgressDidChange(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            userInfo = NSKeyedUnarchiver.unarchiveObjectWithData(pack.context) as? [String: String] {
            let progress = pack.progress
            let completedResources = progress.countOfResourcesCompleted
            let expectedResources = progress.countOfResourcesExpected
            let progressPercentage = Float(completedResources) / Float(expectedResources)
            if completedResources == expectedResources {
                let byteCount = NSByteCountFormatter.stringFromByteCount(Int64(pack.progress.countOfBytesCompleted), countStyle: NSByteCountFormatterCountStyle.Memory)
                print("Offline pack “\(userInfo["name"])” completed: \(byteCount), \(completedResources) resources")
            } else {
                print("Offline pack “\(userInfo["name"])” has \(completedResources) of \(expectedResources) resources — \(progressPercentage * 100)%.")
            }
        }
    }
    
    func offlinePackDidReceiveError(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            userInfo = NSKeyedUnarchiver.unarchiveObjectWithData(pack.context) as? [String: String],
            error = notification.userInfo?[MGLOfflinePackErrorUserInfoKey] as? NSError {
            print("Offline pack “\(userInfo["name"])” received error: \(error.localizedFailureReason)")
        }
    }
    
    func offlinePackDidReceiveMaximumAllowedMapboxTiles(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            userInfo = NSKeyedUnarchiver.unarchiveObjectWithData(pack.context) as? [String: String],
            maximumCount = notification.userInfo?[MGLOfflinePackMaximumCountUserInfoKey]?.unsignedLongLongValue {
            print("Offline pack “\(userInfo["name"])” reached limit of \(maximumCount) tiles.")
        }
    }

}

