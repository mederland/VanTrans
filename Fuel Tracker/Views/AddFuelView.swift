//
//  AddFuelView.swift
//  Fuel Tracker
//
//  Created by Meder iZimov on 3/12/23.
//

import SwiftUI
import Combine

struct AddFuelView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var city = ""
    @State private var summaries = ""
    var body: some View {
        Form {
            Section {
                TextField("Fuel City", text: $city)
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
    }
}

struct AddFuelView_Previews: PreviewProvider {
    static var previews: some View {
        AddFuelView()
    }
}
