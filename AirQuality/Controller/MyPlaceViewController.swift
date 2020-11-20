//
//  AirQualityLocationViewController.swift
//  AirQuality
//
//  Created by Katarina Tomic on 7/31/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import UIKit
import CoreData
import SwiftUI

class MyPlaceViewController: UIViewController {
    
    var selectedCityName: String?
    var allPlaces = [Place]()
    var placesTableDataSource = [Place]()
    var cities = [City]()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    
    @IBAction func AddPlaceButton(_ sender: Any) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let cityListVC = main.instantiateViewController(withIdentifier: "secondVC")
        self.navigationController?.pushViewController(cityListVC, animated: true)
        
        
    }
    
    @IBOutlet weak var placeSearchBar: UISearchBar!
    @IBOutlet weak var placeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        placeSearchBar.delegate = self
        navigationItem.hidesBackButton = true
        let placesDB = DataBaseManager.shared.fetchPlacesFromCoreData()
        if selectedCityName != nil  {
        spinner.startAnimating()
        if placesDB.isEmpty {
                self.fetchMeasurmentPlaceAndReloadData()
               
            } else {
                for placeDB in placesDB {
                    if placeDB.city == selectedCityName {
                        self.allPlaces = placesDB
                        self.placesTableDataSource = self.allPlaces
                        spinner.startAnimating()
                        DispatchQueue.main.async {
                            self.placeTableView.reloadData()
                            self.spinner.stopAnimating()
                        }
                        
                        return
                    }
                }
                fetchMeasurmentPlaceAndReloadData()
                
            }
        } else {
            if placesDB.isEmpty {
                self.placeSearchBar.isHidden = true
            } else {
                self.allPlaces = placesDB      //?
                self.placesTableDataSource = self.allPlaces //?
                
               self.spinner.hidesWhenStopped = true
                
                let timeToLive: TimeInterval = 60 * 60 * 3
                    for placeDB in placesDB {
                        let today = Date()
                        let df = DateFormatter()
                        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
                        let now = df.string(from: today)
                        let isExpired = today.timeIntervalSince(placeDB.updatedAt)
                        let updateAt = placeDB.updatedAt
                        let updateAtString = df.string(from: updateAt)
                        if isExpired >= timeToLive {
                            DataController.shared.getMeasurementsFromPeriodFromAPI(city: placeDB.city, parameter: "pm25" , sort: "desc", date_from: updateAtString, date_to: now, order_by: "date"){(measurements) in
                                if measurements != nil && !measurements!.isEmpty {
                                    if measurements!.first?.value != placeDB.measurementValue {
                                        placeDB.measurementValue = measurements!.first!.value
                                        placeDB.measurementDate.local = measurements!.first!.date.local
                                    }
                                    
                                    DataBaseManager.shared.updatePlaces(currentCityName: placeDB.city, newCityValue: measurements!.first!.value, newUpDateAt: today, newMeasurementDate:measurements!.first!.date)
                                    
                                    self.allPlaces = DataBaseManager.shared.fetchPlacesFromCoreData()
                                    self.placesTableDataSource = self.allPlaces
                                    DispatchQueue.main.async {
                                        self.placeTableView.reloadData()
                                       
                                        self.spinner.stopAnimating()
                                        self.spinner.hidesWhenStopped = true
                            
                                    }
                                    
                                }
                                
                            }
                           
                            
                        }
                        
                    }
                
            }
            
        }
        
    }
    
    func fetchMeasurmentPlaceAndReloadData(){
        DataController.shared.getMeasurementsFromAPI(city:selectedCityName,parameter:"pm25", sort: "asc") { [self] (measurements) in
            if measurements != nil && !measurements!.isEmpty{
                let dateCurrent = Date()
                let measurement = measurements?.first
                let place = Place(city:measurement!.city, measurementDate: measurement!.date, measurementValue: measurement!.value, updatedAt: dateCurrent )
                self.fetchCountries { countries in
                    if countries != nil {
                        let countryName = countries!.filter{$0.code == measurement?.country}.first?.name
                        measurement?.countryName = countryName
                        place.countryName = countryName
                        
                        DataBaseManager.shared.savePlaces(places: place)
                        self.allPlaces = DataBaseManager.shared.fetchPlacesFromCoreData()
                        self.placesTableDataSource = self.allPlaces
                        
                        DispatchQueue.main.async {
                            self.spinner.startAnimating()
                            self.placeTableView.reloadData()
                            self.spinner.stopAnimating()
                            self.spinner.hidesWhenStopped = true
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    spinner.startAnimating()
                    self.allPlaces = DataBaseManager.shared.fetchPlacesFromCoreData()
                    self.placesTableDataSource = self.allPlaces
                    let alertController = UIAlertController(title: "", message: "No measurement data for \(selectedCityName!)", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    self.placeTableView.reloadData()
                    self.spinner.stopAnimating()
                    self.spinner.hidesWhenStopped = true
                    
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
        return placesTableDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityInformation", for: indexPath) as! MyPlaceTableViewCell
        
        cell.cityNameLabel.text = placesTableDataSource[indexPath.row].city
        
        let y = Double(round(100*placesTableDataSource[indexPath.row].measurementValue)/100)
        cell.airQualityLabel.text = String(y)
        let measurmentDate = placesTableDataSource[indexPath.row].measurementDate.local
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:measurmentDate)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let finalDateStrint = dateFormatter.string(from:date!)
        cell.dateLabel.text = finalDateStrint
        cell.countryNameLabel.text = placesTableDataSource[indexPath.row].countryName
        return cell
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity =  self.placesTableDataSource[indexPath.row].city
        let vc = storyboard?.instantiateViewController(identifier: "cityDetail") as! CityDetailViewController
            vc.cityName = selectedCity
            self.navigationController?.pushViewController(vc, animated: true)
        }
    func fetchCountries(completion: @escaping ([Country]?) -> Void){
        DataController.shared.getCountriesFromAPI{ (countries) in
            completion(countries)

        }
    }
    
}

extension MyPlaceViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            self.placesTableDataSource = self.allPlaces
            placeTableView.reloadData()
            return
            
        }
        self.placesTableDataSource = self.allPlaces.filter({ (place) -> Bool in
            return place.city.lowercased().contains(searchText.lowercased())
        })
        placeTableView.reloadData()
    }
    
}



