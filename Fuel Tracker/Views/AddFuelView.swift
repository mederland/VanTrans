//
//  AddFuelView.swift
//  Fuel Tracker
//
//  Created by Meder iZimov on 3/12/23.
//

import SwiftUI
import Combine

struct AddFuelView: View {
    @StateObject var deviceLocationService = DeviceLocationService.shared
    
    @ObservedObject var locViewModel = LocViewModel()
    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon: Double) = (0,0)
    @State private var showDetais = false
    
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var city = ""
    @State private var summaries = ""
    var body: some View {
        let binding = Binding<String>(get: {
                    self.city
        }, set: {_ in
                    self.city = "\(locViewModel.getAddressFromLatLon(pdblLatitude: "\(coordinates.lat)", withLongitude: "\(coordinates.lon)"))"
                    // do whatever you want here
                })
    return Form {
            Section {
                TextField("\(city)", text: binding)
                HStack {
                    Text("Fuel :")
                    TextField("Amount of gas in $: ", text: $summaries)
                        .keyboardType(.decimalPad)
                }
                .padding()
                HStack{
                    Spacer()
                    Button("Submit"){
                        DataController().addFuel(city: city, summary: Float(summaries) ?? 0.0, context: managedObjContext)
                        dismiss()
                    }
                }
            }
        }
    .onAppear {
        observeCoordinateUpdates()
        observeLocationAccessDenied()
        deviceLocationService.requestLocationUpdates()
    }
    }
    func observeCoordinateUpdates() {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
            }
            .store(in: &tokens)
    }
    
    func observeLocationAccessDenied() {
        deviceLocationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("Show Alert to user!")
            }
            .store(in: &tokens)
    }
}

struct AddFuelView_Previews: PreviewProvider {
    static var previews: some View {
        AddFuelView()
    }
}
