//
//  DataController+City.swift
//  AirQuality
//
//  Created by Katarina Tomic on 8/6/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import Foundation

extension DataController {
    
    func getCitiesFromAPI(countryCode: String?, completion: @escaping ([City]?) -> Void) {
        let endpoint = "/cities"
        var queryParams = [String:String]()
        if countryCode != nil {
            queryParams["country"] = countryCode
        }
        executeRequest(endpoint: endpoint, method: .get, queryParams: queryParams) { (data, statusCode, error) in
              if statusCode == .ok && data != nil {

                  let citiesResponse = try! JSONDecoder().decode(CitiesResponse.self, from:data!)
                let result = citiesResponse.results
                  completion(result)
                  
                  
              } else {
                  completion(nil)
              }
            }
   }
}
