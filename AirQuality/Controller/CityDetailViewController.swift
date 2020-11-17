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
import GoogleMaps

class CityDetailViewController: UIViewController {
    
    var cityName: String?
    var measurements = [Measurements]()
    
    @IBOutlet weak var cityDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityDetailTableView.bounces = false
        self.title = cityName
        let measurementsDB = DataBaseManager.shared.fetchMeasurementsFromCoreData()
        if cityName != nil {
            if measurementsDB.isEmpty  {
                self.fetchMeasurmentCityAndReloadData()
                
            } else {
                for measurementDB in measurementsDB {
                    if measurementDB.city == cityName {
                        DispatchQueue.main.async {
                            self.measurements = measurementsDB
                            self.cityDetailTableView.reloadData()
                            
                        }
                        return
                    }
                    
                }
                self.fetchMeasurmentCityAndReloadData()
                
            }
            
        } else {
            DispatchQueue.main.async {
                self.measurements = measurementsDB
                self.cityDetailTableView.reloadData()
                }
                
            }
    
        }
    
    func fetchMeasurmentCityAndReloadData() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateToString = formatter.string(from: date)
        let newDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        formatter.dateFormat = "yyyy-MM-dd"
        let dateFromString = formatter.string(from: newDate!)
        print(dateFromString)
        DataController.shared.getMeasurementsFromPeriodFromAPI(city:cityName ,parameter:"pm25", sort: "asc", date_from: dateFromString, date_to:dateToString){(measurements) in
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
                DispatchQueue.main.async {
                    self.measurements = measurmentsByDates
                    self.cityDetailTableView.reloadData()
                    
                }
                
            }
            }
            
    }
    }
        



extension CityDetailViewController:UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.measurements.isEmpty ? 0 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.measurements.isEmpty ? 0 : 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cityDetailCell", for: indexPath) as! CityDetailTableViewCell
            cell.measurements = self.measurements
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell") as! MapTableViewCell
            let lat = measurements[indexPath.row].coordinates.latitude
            let long = measurements[indexPath.row].coordinates.longitude
            cell.setupMapView(latitude: lat, longitude: long)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height:CGFloat = 0
        for view in self.view.subviews {
            height = height + view.bounds.size.height
        }
        print(height)
        if indexPath.section == 0 {
            return height * 1/3
        } else {
            return height * 2/3
        }
       
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

