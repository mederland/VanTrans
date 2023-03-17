//
//  DayView.swift
//  Fuel Tracker
//
//  Created by Meder iZimov on 3/15/23.
//

import SwiftUI
import Foundation
import CoreData

struct DayView: View {
    @Environment(\.managedObjectContext) var manageObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var fuel: FetchedResults<Fuel>
    
    @State private var showingAddView = false
    @Binding var chosenDate: Date
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Spacer()
                    Text("\(String(format: "%.2f", totalSummaryToday())) $ Total")
                        .foregroundColor(.blue)
                        .font(.system(size: 20))
                        .padding(.horizontal)
                    Spacer()
                }

                List {
                    ForEach(fuel) { fuel in
                if convertDate(givenDate: fuel.date!) == convertDate(givenDate: chosenDate) {
                    NavigationLink(destination: EditFuelView(fuel: fuel)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(fuel.city!)
                                        .bold()
                                    Text("$ ") +
                                    Text("\(String(format: "%.2f",fuel.summary))")
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text(calcTime(date: fuel.date!))
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                        }
                    .navigationBarBackButtonHidden(true)
                        }
                        
                    }
                    .onDelete(perform: deleteFuel)
                }
                .listStyle(.plain)
            }
            .padding()
            .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Text("Fuel Trucker")
                        .foregroundColor(.gray)
                        .font(.system(size: 25))
                    .font(.largeTitle.bold())
                     .accessibilityAddTraits(.isHeader)
                }
                Spacer()
            }
                ToolbarItem(placement: .navigationBarTrailing) {
                        Text(chosenDate, format: .dateTime.day().month().year())
                               .foregroundColor(.gray)
                               .font(.system(size: 20))
                               .padding(.horizontal)
                }
        }
            .sheet(isPresented: $showingAddView){
                AddFuelView()
            }
        }
        .navigationViewStyle(.stack)
    }
    
    
    
private func deleteFuel(offsets: IndexSet){
        withAnimation {
            offsets.map {fuel[$0]}.forEach(manageObjContext.delete)
            DataController().saveData(context: manageObjContext)
        }
    }
    
 func totalSummaryToday() -> Float {
    var summaryToday: Float = 0.0
    
        for item in fuel {
            if convertDate(givenDate: item.date!) == convertDate(givenDate: chosenDate) {
                summaryToday += item.summary
            }
        }
        return summaryToday
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(chosenDate: .constant(Date()))
    }
}
