//
//  Place.swift
//  AirQuality
//
//  Created by Katarina Tomic on 10/19/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import Foundation

class Place {
    var city: String
    var measurementDate: MeasurementsDate
    var countryName: String?
    var measurementValue: Double
    var updatedAt: Date
    
    init(city:String, measurementDate: MeasurementsDate, measurementValue: Double, updatedAt: Date) {
        self.city = city
        self.measurementDate = measurementDate
        self.measurementValue = measurementValue
        self.updatedAt = updatedAt
    }
    
}
