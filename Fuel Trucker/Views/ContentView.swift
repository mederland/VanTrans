//
//  ContentView.swift
//  Fuel Trucker
//
//  Created by Meder iZimov on 3/12/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var manageObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var fuel: FetchedResults<Fuel>
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Button{
                        showingAddView.toggle()
                    } label: {
                        Label("", systemImage: "plus.circle")
                            .font(.system(size: 40))
                    }
                    Spacer()
//                    Image(systemName: "globe")
//                        .imageScale(.large)
//                        .foregroundColor(.accentColor)
                    Text("\(Float(totalSummaryToday())) $ Today")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    Spacer()
                }

                List {
                    ForEach(fuel) { fuel in
                        NavigationLink(destination: EditFuelView(fuel: fuel)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(fuel.city!)
                                        .bold()
                                    Text("$ ") +
                                    Text("\(fuel.summary)")
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text(calcTime(date: fuel.date!))
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                        }
                    }
                    .onDelete(perform: deleteFuel)
                }
                .listStyle(.plain)
            }
            .padding()
            .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
             Text("Fuel Trucker")
                .font(.largeTitle.bold())
                 .accessibilityAddTraits(.isHeader)
                Spacer()
            }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    HStack{
//                        Button{
//                            showingAddView.toggle()
//                        } label: {
//                            Label("Fueling", systemImage: "plus.circle")
//                        }
//                        Spacer()
//                        EditButton()
//                    }
//                }
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
    private func totalSummaryToday() -> Float {
        var summaryToday: Float = 0.0
        for item in fuel {
            if Calendar.current.isDateInToday(item.date!) {
                summaryToday += item.summary
            }
        }
        return summaryToday
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
