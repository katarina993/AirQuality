//
//  CountriesResponse.swift
//  AirQuality
//
//  Created by Katarina Tomic on 8/7/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import Foundation

class CountriesResponse: Codable {
    var meta: Meta
    var results: [Country]
}
