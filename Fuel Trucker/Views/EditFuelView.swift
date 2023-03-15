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
    @State private var summaries: Float = 0.0
    
    var body: some View {
        Form {
            Section {
                TextField("\(fuel.city!)", text: $city)
                    .onAppear {
                        city = fuel.city!
                        summaries = fuel.summary
                    }
                VStack {
                    Text("Total: \(String(summaries))")
//                    TextField("Total: ", text: $summaries)
                    Slider(value: $summaries, in: 0...1000, step: 0.01)
                }
                .padding()
                
                HStack {
                    Spacer()
                    Button("Submit"){
                        DataController().editFuel(fuel: fuel, city: city, summary: summaries, context: managedObjContext)
                            dismiss()
                    }
                }
            }
        }
    }
}

