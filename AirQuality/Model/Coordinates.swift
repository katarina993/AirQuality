//
//  Coordinates.swift
//  AirQuality
//
//  Created by Katarina Tomic on 8/13/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import Foundation

class Coordinates: Codable {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double,longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
