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
    
    
    var zoom: Float = 1
    
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
            let camera = GMSCameraPosition.camera(withLatitude: data.measurementCoordinate.latitude!, longitude: data.measurementCoordinate.longitude!, zoom: zoom)
                        mapView.camera = camera
            
            let dateFormatter = data.measurementDate.local
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let showDate = inputFormatter.date(from:dateFormatter)
            inputFormatter.dateFormat = "yyyy-MM-dd"
            let resultString = inputFormatter.string(from: showDate!)
            
            let value = Double(round(1*(data.measurementValue))/1)
            let valueInt = Int(value)
            let marker = CustomMarker(measurementsValue: valueInt)
           
            marker.position = CLLocationCoordinate2DMake(data.measurementCoordinate.latitude!, data.measurementCoordinate.longitude!)
          
            marker.icon = UIImage(named: "map_marker_icon")
            
            marker.title = data.countryName
            marker.snippet = "\(String(data.city)) \n\(resultString)"
            marker.map = self.mapView
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.showCurrentLocationOnMap()
        self.locationManager.stopUpdatingLocation()
        
    }
   

}
