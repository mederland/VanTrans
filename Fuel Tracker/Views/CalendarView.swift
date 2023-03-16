//
//  CalendarView.swift
//  Fuel Trucker
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
               DatePicker("Fuel Date", selection: $chosenDate, in: ...Date(), displayedComponents: .date)
                   .datePickerStyle(GraphicalDatePickerStyle())
                   .onChange(of: chosenDate, perform: { value in
                       print(chosenDate)
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { //this is because, otherwise user will not see the date selection on date picker
                           navigationActive = true
                       }
               })
           NavigationLink("", destination: DayView(), isActive: $navigationActive)
       }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
