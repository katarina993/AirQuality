//
//  DataController+Country.swift
//  AirQuality
//
//  Created by Katarina Tomic on 8/7/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import Foundation

extension DataController {

    func getCountriesFromAPI(completion: @escaping ([Country]?) -> Void) {
    let endpoint = "/countries"
    executeRequest(endpoint: endpoint, method: .get) { (data, statusCode, error) in
        if statusCode == .ok && data != nil {
            let countriesResponse = try! JSONDecoder().decode(CountriesResponse.self, from:data!)
            var result = countriesResponse.results
            print(countriesResponse.results)
            result = countriesResponse.results.filter(){$0.name != nil}
            result = result.filter(){!$0.name!.isEmpty}

            print(result)
            
            completion(result)
            
        } else {
            
            completion(nil)
            
        }
        
    }
        
    }
    
}
 
