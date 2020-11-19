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
    
    //MARK: MEASUREMENTS
    
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
    
    //MARK: PLACES
    
    func savePlaces(places:Place) -> PlacesLocal {
        let managedContext = getContext()!
        let placesLocal = PlacesLocal(context: managedContext)
        placesLocal.city = places.city
        placesLocal.countryName = places.countryName
        placesLocal.measurementValue = places.measurementValue
        placesLocal.updatedAt = places.updatedAt
        
        let dateLocal = DateLocal(context: managedContext)
        dateLocal.local = places.measurementDate.local
        dateLocal.utc = places.measurementDate.utc
        placesLocal.measurementDate = dateLocal
        do {
            try managedContext.save()
            
        }
        catch let error as NSError {
            print("Could not save. \(error)")
            
        }
       return placesLocal
    }
    
    func saveListPlacesLocal(places: [Place]) -> [PlacesLocal] {
        var placesArrayLocal = [PlacesLocal]()
        for place in places {
           let placeLocal = self.savePlaces(places: place)
            placesArrayLocal.append(placeLocal)
            
        }
        return placesArrayLocal
    }
    
    func fetchPlacesFromCoreData() -> [Place] {
        let managedContext = getContext()
        let placeFetchRequest = NSFetchRequest<PlacesLocal>(entityName: "PlacesLocal")
        
        do {
            let placesLocal = try managedContext!.fetch(placeFetchRequest)
            print(placesLocal)
            let places = self.convertToListPlaces(placesLocalList: placesLocal)
           return places
        }
        catch let error as NSError {
            print("Could not fetch. \(error)")
            return []
        }
       
        }
    
    func convertPlacesLocalToPlaces(placeLocal: PlacesLocal) -> Place {
        let date = MeasurementsDate(utc: (placeLocal.measurementDate?.utc)!, local: (placeLocal.measurementDate?.local)!)
        let place = Place(city: placeLocal.city!, measurementDate: date, measurementValue: placeLocal.measurementValue, updatedAt: placeLocal.updatedAt!)
        return place
        
    }
    
    func convertToListPlaces(placesLocalList: [PlacesLocal]) -> [Place] {
       var placesArray = [Place]()
        for y in placesLocalList {
            let place = self.convertPlacesLocalToPlaces(placeLocal: y)
            placesArray.append(place)
        }
        return placesArray
    }
    
   
    func updatePlaces(currentCityName:String, newCityValue:Double, newUpDateAt:Date, newMeasurementDate:MeasurementsDate) {
        let managedContext = getContext()!
        let placeFetchRequest = NSFetchRequest<PlacesLocal>(entityName: "PlacesLocal")
        placeFetchRequest.predicate = NSPredicate(format:"city =%@", currentCityName)
        
        do {
            let dateLocal = DateLocal(context: managedContext)
            dateLocal.local = newMeasurementDate.local
            dateLocal.utc = newMeasurementDate.utc
            
            let fetchReturn = try managedContext.fetch(placeFetchRequest)
            let objectUpdate = fetchReturn[0] as NSManagedObject
            objectUpdate.setValue(newCityValue, forKey: "measurementValue")
            objectUpdate.setValue(newUpDateAt, forKey: "updatedAt")
            objectUpdate.setValue(dateLocal, forKey: "measurementDate")
            do {
                try managedContext.save()
                print("updated successfully")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Could not save.\(error), \(error.userInfo)")
        }
    }
    
    
}

