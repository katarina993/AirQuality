//
//  MapTableViewCell.swift
//  AirQuality
//
//  Created by Katarina Tomic on 10/27/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class MapTableViewCell: UITableViewCell, GMSMapViewDelegate {

    @IBOutlet weak var googleMapsView: UIView!
    var googleMaps: GMSMapView!
    var camera = GMSCameraPosition()
    
    func setupMapView(latitude: Double?, longitude: Double?){
        if latitude == nil || longitude == nil {
            return
        }
        let camera = GMSCameraPosition.camera(withLatitude: latitude!, longitude: longitude!, zoom: 10)
        self.googleMaps = GMSMapView.map(withFrame: CGRect(x: 0,y: 0, width: self.googleMapsView.frame.size.width, height: self.googleMapsView.frame.height), camera: camera)
        self.googleMaps.isMyLocationEnabled = true
        self.googleMaps.accessibilityElementsHidden = false

        self.googleMapsView.addSubview(self.googleMaps)
        self.googleMaps.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude!, longitude!)
        ///View for Marker
        let DynamicView = UIView(frame: CGRect(x:0, y:0, width:50, height:50))
        DynamicView.backgroundColor = UIColor.clear
        marker.map = self.googleMaps
    }
}
