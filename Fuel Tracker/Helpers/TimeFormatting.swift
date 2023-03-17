//
//  TimeFormatting.swift
//  Fuel Tracker
//
//  Created by Meder iZimov on 3/12/23.
//

import Foundation

func calcTime(date: Date) -> String {
    let minutes = Int(-date.timeIntervalSinceNow)/60
    let hours = minutes/60
    let days = hours/24
    
    if minutes < 120 {
        return "\(minutes) minutes ago..."
    } else if minutes >= 120 && hours < 48 {
        return "\(hours) hours ago..."
    } else {
        return "\(days) days ago..."
    }
}


func convertDate(givenDate: Date) -> String {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd hh:mm:ss"
    let newFormatedDate = df.string(from: givenDate)
      let date = newFormatedDate
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
    let dateFromString : NSDate = dateFormatter.date(from: date)! as NSDate
      dateFormatter.dateFormat = "dd-MM-yyyy"
    let givenDate = dateFormatter.string(from: dateFromString as Date)
    return givenDate
}

