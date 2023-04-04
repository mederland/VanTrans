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
    @State var startDate = Date()
    @State var endDate = Date()
    @State private var showingAddView = false
    @State private var showingDayView = false
    @State var navigationActive = false
    
    @State private var showingAlert = false
    
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
           NavigationLink(
            destination: DayView(chosenDate: $chosenDate), isActive: $navigationActive)
           {
               Text("Days total: $ \(String(format: "%.2f", totalSummaryToday())) ")
           }
       }
    }
    
    var totalYearView: some View {
            VStack{
                HStack{
                    DatePicker("Start", selection: $startDate, in: ...Date(), displayedComponents: .date)
                    DatePicker("End", selection: $endDate, in: ...Date(), displayedComponents: .date)
                }
                    Text ("Total between Dates is: \(String(format: "%.2f", daysBetweenDates(startDate: startDate, endDate: endDate)))")
                    .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
                    
                HStack{
                    Text("All time total is: ")
                        .font(.system(size: 20).bold())
                        .foregroundColor(.gray)
                    Text("$ \(String(format: "%.2f", totalYear()))")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                    Spacer()
                    Button("Reset") {
                        showingAlert = true
                    }
                    .foregroundColor(.red)
                    .buttonStyle(.bordered)
                    .alert(isPresented: $showingAlert) {
                        Alert(
                        title: Text("Are you sure, you want to delete all your data?")
                            .foregroundColor(.red),
                        message: Text("All your saved data will be DELETED")
                            .foregroundColor(.orange),
                        primaryButton: .destructive(Text("Delete")){
                            deleteAllFromDB()
                        },
                        secondaryButton: .cancel()
                        )
                    }
                    .padding()
                }
                .padding()
            }
    }
    
    func daysBetweenDates(startDate : Date, endDate: Date) -> Float {
        let calendar = Calendar.current
        var weekTotal: Float = 0.0
        var currentDate = startDate
        while currentDate <= endDate {
            for item in fuel {
                if convertDate(givenDate: item.date!) == convertDate(givenDate: currentDate) {
                    weekTotal += item.summary
                }
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
//            print("\(currentDate) insideof \(weekTotal)")
        }
        return weekTotal
    }
    
    
    
    func deleteAllFromDB(){
               fuel.forEach(manageObjContext.delete)
               DataController().saveData(context: manageObjContext)
       }
   
    func totalYear() -> Float {
           var yearTotal: Float = 0.0
           for item in fuel {
                   yearTotal += item.summary
           }
           return yearTotal
       }
   
//    func totalToday() -> Float {
//           var todayTotal: Float = 0.0
//           for item in fuel {
//               if Calendar.current.isDateInToday(item.date!) {
//                   todayTotal += item.summary
//               }
//           }
//           return todayTotal
//       }
   
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




struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
