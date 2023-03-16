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
    var body: some View {
        NavigationView{
            VStack{
                calendarDatePickerView
            }
            .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
             Text("Fuel Trucker")
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
                   .overlay(
                    Button(action: {
                        showingDayView.toggle()
                    }, label: {
                        EmptyView()
                    })
                    .sheet(isPresented: $showingDayView){
                        DayView()
                    }
                   )
       }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
