//
//  Measurements.swift
//  AirQuality
//
//  Created by Katarina Tomic on 8/13/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import Foundation

class Measurements: Codable {
    var location: String
    var parameter: String
    var date: MeasurementsDate
    var value: Double
    var unit: String
    var coordinates: Coordinates
    var country: String
    var city: String
    var countryName: String?
    
    init(dict: [String: Any]) {
        self.location = dict["location"] as! String
        self.parameter = dict["parameter"] as! String
        self.date = dict["date"] as! MeasurementsDate
        self.value = dict["value"] as! Double
        self.unit = dict["unit"] as! String
        self.coordinates = dict["coordinates"] as! Coordinates
        self.country = dict["country"] as! String
        self.city = dict["city"] as! String
        self.countryName = dict["countryName"] as? String
    }
    init(location:String,parametar: String, date:MeasurementsDate,value:Double,unit:String,coordinates: Coordinates, country: String, city: String, countryName: String?) {
        self.location = location
        self.parameter = parametar
        self.city = city
        self.coordinates = coordinates
        self.countryName = countryName
        self.unit = unit
        self.date = date
        self.value = value
        self.country = country
        
    }

    func getAirQualityByValue() -> AirQuality {
        if self.value <= 12 {
            return .good
            
        } else if self.value > 12 && value < 35 {
            return .moderatelyGood
            
        } else if value > 35 && value < 55 {
            return .sensitiveBeware
            
        } else if value > 55 && value < 150 {
            return.unhealthy
            
        } else if value > 150 && value < 150 {
            return.veryUnhealthy
            
        } else {
            return.hazardous
            
        }
        
    }
    
}

