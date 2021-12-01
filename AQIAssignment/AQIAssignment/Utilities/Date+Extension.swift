//
//  Date+Extension.swift
//  AQIAssignment
//
//  Created by Ankur Batham on 24/11/21.
//

import Foundation
let gregorianCalendar = Calendar(identifier: .gregorian)

extension Date{
    func toSecond() -> Int64! {
        return Int64(self.timeIntervalSince1970)
    }
  
    static func timeDifference(time1: Date, time2: Date) -> Int {
        let difference = gregorianCalendar.dateComponents([.second], from: time1, to: time2)
        return difference.second ?? 0
    }
    
    func string(with format: DateFormatter) -> String {
        return format.string(from: self)
    }
}

extension DateFormatter {
    static let time12period: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.calendar = gregorianCalendar
        return formatter
    }()
}
