//
//  Results.swift
//  AirQuality
//
//  Created by Katarina Tomic on 8/7/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import Foundation

class Country: Codable, CustomStringConvertible {
    var code: String
    var count: Int
    var locations: Int
    var cities: Int
    var name: String?
    
    public var description: String { return "Code: \(code), name: \(name ?? "")" }

    
}
