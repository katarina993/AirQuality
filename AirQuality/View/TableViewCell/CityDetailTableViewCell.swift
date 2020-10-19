//
//  CityDetailTableViewCell.swift
//  AirQuality
//
//  Created by Katarina Tomic on 9/4/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import UIKit

class CityDetailTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    var measurements = [Measurements]() {
        didSet {
            cityDetailCollectionView.reloadData()
        }
    }
    
        

    @IBOutlet weak var cityDetailCollectionView: UICollectionView!
    
    override func awakeFromNib() {
    super.awakeFromNib()
        cityDetailCollectionView.delegate = self
        cityDetailCollectionView.dataSource = self

        cityDetailCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return measurements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CityDetailCollectionViewCell
        let measurement = self.measurements[indexPath.row]
        let x = self.measurements[indexPath.row].date.utc
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let showDate = inputFormatter.date(from:x)
        inputFormatter.dateFormat = "EEEE"
        let resultString = inputFormatter.string(from: showDate!)
        print(resultString)
        cell.dayLabel.text = resultString
        cell.airQualityImage.image = getImageForMeasurements(value: measurement.getAirQualityByValue())
        cell.valueLabel.text = String(measurement.value)
        
        return cell
    }
   
}

