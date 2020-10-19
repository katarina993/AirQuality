//
//  CityDetailViewController.swift
//  AirQuality
//
//  Created by Katarina Tomic on 9/4/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import UIKit
import CoreData
import UIKit

class CityDetailViewController: UIViewController {
    
    
    var cityD: City?
    var measurements = [Measurements]()
    
    
    
    @IBOutlet weak var cityDetailTableView: UITableView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = cityD?.name
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateToString = formatter.string(from: date)
        let newDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        formatter.dateFormat = "yyyy-MM-dd"
        let dateFromString = formatter.string(from: newDate!)
        print(dateFromString)
        
        if cityD != nil {
            let measurementF = DataBaseManager.shared.fetchMeasurementsFromCoreData()
            if measurementF.isEmpty  {
            DataController.shared.getMeasurementsFromPeriodFromAPI(city:cityD!.name ,parameter:"pm25", sort: "asc", date_from: dateFromString, date_to:dateToString){(measurements) in
                if measurements != nil{
                    var measurmentsByDates = [Measurements]()
                    for y in measurements! {
                        let x = y.date.utc
                        let inputFormatter = DateFormatter()
                        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        let showDate = inputFormatter.date(from:x)
                        inputFormatter.dateFormat = "yyyy-MM-dd"
                        let resultString = inputFormatter.string(from: showDate!)
                        print(resultString)
                        if resultString == dateToString {
                            measurmentsByDates.append(y)
                           break
                        }
                    }
                    var value = -1
                    let now = Date()
                    
                    for z in measurements! {
                        let zFormatter = z.date.utc
                        let inputFormatter = DateFormatter()
                        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        let showDate = inputFormatter.date(from:zFormatter)
                        inputFormatter.dateFormat = "yyyy-MM-dd"
                        let resultStringZ = inputFormatter.string(from: showDate!)
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let newX = Calendar.current.date(byAdding: .day, value: value, to: now)
                        let newResultString = newX!.toString(dateFormat: "yyyy-MM-dd")
                        if newResultString == resultStringZ {
                            measurmentsByDates.append(z)
                            value -= 1
                            continue
                        }
                        if value <= -7{
                            break
                        }

                        print(newResultString)
                        
                    }
                    DataBaseManager.shared.saveListMeasurementsLocal(measurements: measurmentsByDates)
                    let measurementLocal = DataBaseManager.shared.fetchMeasurementsFromCoreData()
                    print("KACA:\(measurementLocal)")
                    self.measurements = measurmentsByDates
                    DispatchQueue.main.async {
                        self.cityDetailTableView.reloadData()
                        
                    }
                    
                }
                
            }
                
            } else {
                self.measurements = measurementF
                DispatchQueue.main.async {
                    self.cityDetailTableView.reloadData()
                    
                }
                
            }
            
        } else {
            
        }
        
    }
    
}
    
    


extension CityDetailViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityDetailCell", for: indexPath) as! CityDetailTableViewCell
       
        cell.measurements = self.measurements
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
}
extension Date {
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

func getImageForMeasurements(value: AirQuality ) -> UIImage? {
    switch value {
    case .good:
           return UIImage(named: "Good")
    case .moderatelyGood:
           return UIImage(named: "ModeratelyGood")
    case .sensitiveBeware:
           return UIImage(named: "SensitiveBeware")
    case .unhealthy:
           return UIImage(named: "Unhealthy")
    case .veryUnhealthy:
           return UIImage(named: "VeryUnhealthy")
       case .hazardous:
           return UIImage(named: "Hazardous")
    }
}
