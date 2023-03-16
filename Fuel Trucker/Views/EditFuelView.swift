//
//  EditFuelView.swift
//  Fuel Trucker
//
//  Created by Meder iZimov on 3/12/23.
//

import SwiftUI

struct EditFuelView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var fuel: FetchedResults<Fuel>.Element
    @State private var city = ""
    @State private var summaries = ""
    
    var body: some View {
        Form {
            Section {
                TextField("\(fuel.city!)", text: $city)
                    .onAppear {
                        city = fuel.city!
                        summaries = String(fuel.summary)
                    }
                HStack {
                    Text("Fuel :")
                    TextField("Amount of gas in $:  ", text: $summaries)
                        .keyboardType(.decimalPad)
                }
                .padding()
                
                HStack {
                    Spacer()
                    Button("Submit"){
                        DataController().editFuel(fuel: fuel, city: city, summary: Float(summaries) ?? 0.0, context: managedObjContext)
                            dismiss()
                    }
                }
            }
        }
    }
}

