//
//  CalendarView.swift
//  Fuel Tracker
//
//  Created by Meder iZimov on 3/15/23.
//

import SwiftUI

struct CalendarView: View {
    @Environment(\.managedObjectContext) var manageObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var fuel: FetchedResults<Fuel>
    
    @State var chosenDate = Date()
    @State private var showingAddView = false
    @State private var showingDayView = false
    @State var navigationActive = false
    var body: some View {
        NavigationView{
            VStack{
                calendarDatePickerView
                Spacer()
                totalYearView
            }
            .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
             Text("Fuel Tracker")
                .font(.largeTitle.bold())
                 .accessibilityAddTraits(.isHeader)
                Spacer()
            }
        }
            .sheet(isPresented: $showingAddView){
                AddFuelView()
            }
        }
    }
    
    var calendarDatePickerView: some View {
       Form {
           HStack{
               Button{
                   showingAddView.toggle()
               } label: {
                   HStack{
                       Label("", systemImage: "plus.circle")
                           .font(.system(size: 40))
                       Text("Add fuel")
                           .font(.system(size: 20))
                   }
               }
               Spacer()
               Text(Date.now, format: .dateTime.day().month().year())
                      .foregroundColor(.gray)
                      .font(.system(size: 20))
                      .padding(.horizontal)
           }
               DatePicker(".", selection: $chosenDate, in: ...Date(), displayedComponents: .date)
                   .datePickerStyle(GraphicalDatePickerStyle())
                   .onChange(of: chosenDate, perform: { value in
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { //this is because, otherwise user will not see the date selection on date picker
                           navigationActive = true
                       }
               })
           NavigationLink("Today's total is: $ \(String(format: "%.2f", totalToday())) ", destination: DayView(chosenDate: $chosenDate), isActive: $navigationActive)
       }
    }
    
    var totalYearView: some View {
        VStack{
            HStack{
                Text("All time total is: ")
                    .font(.system(size: 20).bold())
                    .foregroundColor(.gray)
                Text("$ \(String(format: "%.2f", totalYear()))")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                Spacer()
                Button("Reset") {
                    print("Reset all data")
                }
                .buttonStyle(.bordered)
                .padding()
            }
            .padding()
        }
    }
    
    private func totalYear() -> Float {
            var yearTotal: Float = 0.0
            for item in fuel {
                    yearTotal += item.summary
            }
            return yearTotal
        }
    
    private func totalToday() -> Float {
            var todayTotal: Float = 0.0
            for item in fuel {
                if Calendar.current.isDateInToday(item.date!) {
                    todayTotal += item.summary
                }
            }
            return todayTotal
        }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
