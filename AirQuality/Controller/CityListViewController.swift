//
//  CityListViewController.swift
//  AirQuality
//
//  Created by Katarina Tomic on 8/6/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
  
    @IBOutlet weak var chooseCountryButton: UIButton!
    var cities = [City]()
    var countries = [Country]()
    let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
    var date = [MeasurementsDate]()
    
    
    @IBOutlet weak var citiesTableView: UITableView!
    
   
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DataController.shared.getCountriesFromAPI() { countries in
            if countries != nil {
                self.countries = countries!
                DispatchQueue.main.async {
                    self.citiesTableView.reloadData()
                }
                
            } else {
                //error
                
            }
            
        }
        
    }
    //MARK: TABLE VIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityListIdentifier", for: indexPath) as! CityListTableViewCell
        let country = countries[indexPath.row]
        cell.cityNameLabel.text = country.name
        return cell
       }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry =  self.countries[indexPath.row].code
        DataController.shared.getCitiesFromAPI(countryCode: selectedCountry) { cities in
            self.cities = cities!
            DispatchQueue.main.async {
                self.showAlertToUser()
            }
        }
    }
}

    //MARK: PICKER VIEW
extension CityListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
    }
    
    func showAlertToUser() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "Choose city", message: "", preferredStyle: UIAlertController.Style.alert)
            editRadiusAlert.setValue(vc, forKey: "contentViewController")
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            let selectedValue = self.cities[self.pickerView.selectedRow(inComponent: 0)].name
            self.addMyPlace(cityName: selectedValue)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        editRadiusAlert.addAction(okAction)
        editRadiusAlert.addAction(cancelAction)
        self.present(editRadiusAlert, animated: true)
        
    }
    
    func addMyPlace(cityName: String) {
        let vc = storyboard?.instantiateViewController(identifier: "firstVC") as! MyPlaceViewController
        vc.selectedCityName = cityName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

    
   


