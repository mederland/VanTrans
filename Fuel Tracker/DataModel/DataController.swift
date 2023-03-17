//
//  DataController.swift
//  Fuel Tracker
//
//  Created by Meder iZimov on 3/12/23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer (name: "FuelModel")
    
    init() {
        container.loadPersistentStores { descript, error in
            if let error = error {
                print ("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    func saveData(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Error in savind Data!")
        }
    }
    
    func addFuel(city: String, summary: Float, context: NSManagedObjectContext){
        let fuel = Fuel(context: context)
        fuel.id = UUID()
        fuel.date = Date()
        fuel.city = city
        fuel.summary = summary
        saveData(context: context)
    }
    
    func editFuel(fuel: Fuel, city: String, summary: Float, context: NSManagedObjectContext){
        fuel.city = city
        fuel.summary = summary
        saveData(context: context)
    }
}
