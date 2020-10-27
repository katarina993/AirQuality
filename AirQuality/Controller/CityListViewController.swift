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
    
   
    @IBAction func chooseCountryButtonTapped(_ sender: Any) {
        showAlertToUser()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chooseCountryButton.isEnabled = false
        DataController.shared.getCountriesFromAPI() { countries in
            if countries != nil {
                self.countries = countries!
                DispatchQueue.main.async {
                    self.chooseCountryButton.isEnabled = true
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
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityListIdentifier", for: indexPath) as! CityListTableViewCell
        let city = cities[indexPath.row]
        cell.cityNameLabel.text = city.name
        return cell
       }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "Do you want to add this city to your favorite list?", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            let selectedCity = self.cities[indexPath.row].name
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "firstVC") as! MyPlaceViewController
            vc.selectedCityName = selectedCity
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        ac.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        ac.addAction(cancelAction)
        present(ac, animated: true, completion: nil)
    }
    
}

    //MARK: PICKER VIEW
extension CityListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

            let valueSelected = countries[row].name
            print(valueSelected!)
        }
       
    func showAlertToUser() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "Choose country", message: "", preferredStyle: UIAlertController.Style.alert)
            editRadiusAlert.setValue(vc, forKey: "contentViewController")
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
            self.showCities()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        editRadiusAlert.addAction(okAction)
        editRadiusAlert.addAction(cancelAction)
        self.present(editRadiusAlert, animated: true)
        
    }
    
    func showCities() {
        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        let selectedCode = self.countries[selectedIndex].code
        DataController.shared.getCitiesFromAPI(countryCode: selectedCode) { cities in
            self.cities = cities!
            DispatchQueue.main.async {
            self.citiesTableView.reloadData()
                
            }
            NSLog("OK Pressed")
            
        }
        
    }
    
    
}

    
   


