//
//  DataController+Date.swift
//  AirQuality
//
//  Created by Katarina Tomic on 9/3/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import Foundation

extension DataController {
    func getMeasurementsFromPeriodFromAPI(city: String?, parameter:String?, sort: String?, date_from:String?, date_to: String? , order_by:String?, completion: @escaping ([Measurements]?) -> Void) {
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
    if date_from != nil {
        queryParams["date_from"] = date_from
    }
    if date_to != nil {
        queryParams["date_to"] = date_to
    }
    if order_by != nil {
        queryParams["order_by"] = order_by
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


