//
//  DataMapper.swift
//  AirQuality
//
//  Created by Katarina Tomic on 10/7/20.
//  Copyright © 2020 Katarina Tomic. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class DataBaseManager: NSObject {
    
    static let shared = DataBaseManager()
    
    func getContext() -> NSManagedObjectContext? {
//        DispatchQueue.main.sync {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            return appDelegate?.persistentContainer.viewContext
//        }
    }
    
    
    func saveMeasurements(measurements:Measurements) -> MeasurementsLocal {
        let managedContext = getContext()!
        let measurmentsLocal = MeasurementsLocal(context: managedContext)
        measurmentsLocal.city = measurements.city
        measurmentsLocal.location = measurements.location
        measurmentsLocal.parametar = measurements.parameter 
        measurmentsLocal.value = measurements.value
        measurmentsLocal.country = measurements.country
        measurmentsLocal.countryName = measurements.countryName
        measurmentsLocal.unit = measurements.unit
        
        let dateLocal = DateLocal(context: managedContext)
        dateLocal.local = measurements.date.local
        dateLocal.utc = measurements.date.utc
        measurmentsLocal.date = dateLocal

        let coordinateLocal = CoordinatesLocal(context: managedContext)
        coordinateLocal.latitude = measurements.coordinates.latitude
        coordinateLocal.longitude = measurements.coordinates.longitude
        measurmentsLocal.coordinate = coordinateLocal
        
        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error)")
        }
        return measurmentsLocal
    
    }
    func retrieveMeasurements() -> [NSManagedObject] {
            let managedContext = getContext()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MeasurementsLocal")
            let result = try! managedContext?.fetch(fetchRequest) as! [NSManagedObject]
            return result
        }
    
    func saveListMeasurementsLocal(measurements: [Measurements]) {
        var measurementsArrayLocal = [MeasurementsLocal]()
        for measurement in measurements {
            let measurementLocal = self.saveMeasurements(measurements: measurement)
            measurementsArrayLocal.append(measurementLocal)
            
        }
        
    }
    
    func fetchMeasurementsFromCoreData() -> [Measurements] {
        let managedContext = getContext()
        let measurementFetchRequest = NSFetchRequest<MeasurementsLocal>(entityName: "MeasurementsLocal")
        
        do {
            let measurementsLocal = try managedContext!.fetch(measurementFetchRequest)
            print(measurementsLocal)
            let measurements = self.convertToList(measurementsLocalList: measurementsLocal)
           return measurements
        }
        catch let error as NSError {
            print("Could not fetch. \(error)")
            return []
        }
       
        }
    
    
    func convertMesurmentsLocalToMeasurements(measurementLocal: MeasurementsLocal) -> Measurements{
       
        let date = MeasurementsDate(utc: (measurementLocal.date?.utc)!, local: (measurementLocal.date?.local)!)
        let coordinates = Coordinates(latitude: (measurementLocal.coordinate?.latitude)!, longitude: (measurementLocal.coordinate?.longitude)!)
        let measurement = Measurements(location:measurementLocal.location!,
                                       parametar: measurementLocal.parametar! ,
                                       date: date ,
                                       value: measurementLocal.value,
                                       unit: measurementLocal.unit!,
                                       coordinates: coordinates,
                                       country:measurementLocal.country! ,
                                       city: measurementLocal.city!,
                                       countryName: measurementLocal.countryName)
        
        return measurement
        
    }
    
    func convertToList(measurementsLocalList: [MeasurementsLocal]) -> [Measurements] {
        var measurementArray = [Measurements]()
        for y in measurementsLocalList {
            let measurement = self.convertMesurmentsLocalToMeasurements(measurementLocal: y)
            measurementArray.append(measurement)
        }
        return measurementArray
    }
    
}
