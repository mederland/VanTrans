//
//  Fuel_TruckerApp.swift
//  Fuel Trucker
//
//  Created by Meder iZimov on 3/12/23.
//

import SwiftUI

@main
struct Fuel_TruckerApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            CalendarView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
