//
//  Date.swift
//  AirQuality
//
//  Created by Katarina Tomic on 8/13/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import Foundation

class MeasurementsDate: Codable {
    var utc: String
    var local: String
    
    init(utc:String,local:String) {
        self.utc = utc
        self.local = local
        
    }
}

