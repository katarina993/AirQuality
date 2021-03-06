//
//  CitiesResponse.swift
//  AirQuality
//
//  Created by Katarina Tomic on 8/7/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import Foundation

class CitiesResponse: Codable {
    var meta: Meta
    var results: [City]
}
