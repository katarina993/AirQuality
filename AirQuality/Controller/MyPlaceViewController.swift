//
//  AirQualityLocationViewController.swift
//  AirQuality
//
//  Created by Katarina Tomic on 7/31/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import UIKit
import CoreData

class MyPlaceViewController: UIViewController {
    
    var selectedCity: String?
    var places = [Place]()

    @IBAction func AddPlaceButton(_ sender: Any) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let cityListVC = main.instantiateViewController(withIdentifier: "secondVC")
        self.navigationController?.pushViewController(cityListVC, animated: true)
        
    }
    @IBOutlet weak var placeSearchBar: UISearchBar!
    @IBOutlet weak var placeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedCity != nil {
            DataController.shared.getMeasurementsFromAPI(city:selectedCity,parameter:"pm25", sort: "asc") { [self] (measurements) in
                if measurements != nil && !measurements!.isEmpty{
                    let dateCurrent = Date()
                    let measurement = measurements?.first
                    let place = Place(city:measurement!.city, measurementDate: measurement!.date, measurementValue: measurement!.value, updatedAt: dateCurrent )
                    self.fetchCountries { countries in
                        if countries != nil {
                            let countryName = countries!.filter{$0.code == measurement?.country}.first?.name
                            measurement?.countryName = countryName
                            place.countryName = countryName
                            self.places.append(place)
                            
                            DataBaseManager.shared.savePlaces(places: place)
                            DispatchQueue.main.async {
                                self.placeTableView.reloadData()
                                
                            }
                            
                        }
                        
                    }
                    
                } else {
                   //greska
                    
                }
                
            }
            
        }
        
    }
    
}

extension MyPlaceViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityInformation", for: indexPath) as! MyPlaceTableViewCell
        
        cell.cityNameLabel.text = places[indexPath.row].city
        cell.airQualityLabel.text = String(places[indexPath.row].measurementValue)
        let measurmentDate = places[indexPath.row].measurementDate.local
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:measurmentDate)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let finalDateStrint = dateFormatter.string(from:date!)
        cell.dateLabel.text = finalDateStrint
        
//        let now = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat  = "EEEE" // "EE" to get short style
//        let dayInWeek = formatter.string(from: now)
        
        cell.countryNameLabel.text = places[indexPath.row].countryName
        return cell
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity =  self.places[indexPath.row].city
        let vc = storyboard?.instantiateViewController(identifier: "cityDetail") as! CityDetailViewController
        vc.cityD = selectedCity
        self.navigationController?.pushViewController(vc, animated: true)
    }
     
    func fetchCountries(completion: @escaping ([Country]?) -> Void){
        DataController.shared.getCountriesFromAPI{ (countries) in
            completion(countries)
        }
    }
    

}


