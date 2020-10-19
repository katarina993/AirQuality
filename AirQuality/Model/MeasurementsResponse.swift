//
//  MeasurementsResponse.swift
//  AirQuality
//
//  Created by Katarina Tomic on 8/13/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import Foundation

class MeasurementsResponse: Codable {
    var meta: Meta
    var results: [Measurements]
}
