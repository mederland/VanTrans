//
//  AddFuelView.swift
//  Fuel Trucker
//
//  Created by Meder iZimov on 3/12/23.
//

import SwiftUI
import Combine

struct AddFuelView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var city = ""
    @State private var summaries: Float = 0.0
    var body: some View {
        Form {
            Section {
                TextField("Fuel City", text: $city)
                VStack {
                    Text("Total: \(String(summaries))")
                    Slider (value: $summaries, in: 0...1000, step: 0.01)
//                    TextField("Total: ", text: $summaries)
                               .keyboardType(.numberPad)
//                               .onReceive(Just(summaries)) { newValue in
//                                   let filtered = newValue.filter { "0123456789".contains($0) }
//                                   if filtered != newValue {
//                                       self.numOfPeople = filtered
//                                   }
//                               }
//                    TextField("Total", text: $summaries)
                }
                .padding()
                HStack{
                    Spacer()
                    Button("Submit"){
                        DataController().addFuel(city: city, summary: summaries, context: managedObjContext)
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
