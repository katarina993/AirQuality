//
//  DataController.swift
//  AirQuality
//
//  Created by Katarina Tomic on 8/5/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import Foundation

let baseURL = "https://api.openaq.org/v1"

enum HTTPMethod: String {
  case get = "GET"
  case post = "PUT"
}

enum HTTPStatusCode {
  case ok
  case badRequest
  case unauthorized
  case tooManyRequests
  case serverError
  case unKnown
  
  init(statusCode: Int) {
    switch statusCode {
    case 200:
      self = .ok
    case 400:
      self = .badRequest
    case 401:
      self = .unauthorized
    case 429:
      self = .tooManyRequests
    case 500:
      self = .serverError
    default:
      self = .unKnown
    }
  }
}


class DataController {

static let shared = DataController()

private init() {}
func executeRequest(endpoint: String,
                      method: HTTPMethod,
                      queryParams: [String: String]? = nil,
                      body: Data? = nil,
                      completion: @escaping (Data?, HTTPStatusCode, Error?) -> Void)
  {
   var urlComp = URLComponents(string: baseURL + endpoint)!

   var items = [URLQueryItem]()

    if queryParams != nil && !queryParams!.isEmpty{
        for (key,value) in queryParams! {
           items.append(URLQueryItem(name: key, value: value))
        }
    }

   items = items.filter{!$0.name.isEmpty}

   if !items.isEmpty {
     urlComp.queryItems = items
   }
    
    var request = URLRequest(url: urlComp.url!)
      request.httpMethod = method.rawValue
      request.httpBody = body
      
      // Add header field
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")

      let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        let statusCode = (response as! HTTPURLResponse).statusCode
        #if DEBUG
        if data != nil {
          if let logMessage = String(data: data!, encoding: .utf8) {
            NSLog("Requested: \(endpoint)")
            NSLog("Status code: \(statusCode)")
            NSLog("Response: \(logMessage)")
          }
        }
        #endif
        
        
        let httpStatusCode = HTTPStatusCode(statusCode: statusCode)
//        sleep(1)
        completion(data, httpStatusCode, error)
      }
      dataTask.resume()
    }
  }
