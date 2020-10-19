//
//  DataController+Measurements.swift
//  AirQuality
//
//  Created by Katarina Tomic on 8/13/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import Foundation

extension DataController {
    func getMeasurementsFromAPI(city: String?, parameter:String?, sort: String? , completion: @escaping ([Measurements]?) -> Void) {
            let endpoint = "/measurements"
            var queryParams = [String:String]()
        if city != nil {
            queryParams["city"] = city
        }
        if parameter != nil {
            queryParams["parameter"] = parameter
        }
        
        if sort != nil {
            queryParams["sort"] = sort
        }
        
            executeRequest(endpoint: endpoint, method: .get, queryParams: queryParams) { (data, statusCode, error) in
                  if statusCode == .ok && data != nil {
                    let measurementsResponse = try!JSONDecoder().decode(MeasurementsResponse.self, from:data!)
                    let result = measurementsResponse.results
                      completion(result)
                      
                      
                  } else {
                      completion(nil)
                  }
                }
       }
    }


