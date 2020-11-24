//
//  MyPlacesMapViewController.swift
//  AirQuality
//
//  Created by Katarina Tomic on 11/23/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import UIKit
import GoogleMaps

class MyPlacesMapViewController: UIViewController, CLLocationManagerDelegate {
    
    var measurements = [Measurements]()
    var cityList = [String]()

    @IBOutlet weak var mapView: GMSMapView!
    
  
    private let locationManager = CLLocationManager()
    var cameraPosition = GMSCameraPosition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        showCurrentLocationOnMap()
        
    }
    
    func showCurrentLocationOnMap(){
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        let places = DataBaseManager.shared.fetchPlacesFromCoreData()
        for data in places {
            let camera = GMSCameraPosition.camera(withLatitude: data.measurementCoordinate.latitude!, longitude: data.measurementCoordinate.longitude!, zoom: 1)
                        mapView.camera = camera
            let position = CLLocationCoordinate2DMake(data.measurementCoordinate.latitude!, data.measurementCoordinate.longitude!)
            let marker = GMSMarker(position: position)
            marker.map = self.mapView
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.showCurrentLocationOnMap()
        self.locationManager.stopUpdatingLocation()
        
    }
    
}


