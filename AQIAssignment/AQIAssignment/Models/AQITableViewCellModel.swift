//
//  AQITableViewCellModel.swift
//  AQIAssignment
//
//  Created by Ankur Batham on 23/11/21.
//

import Foundation
import UIKit

protocol AQITableViewCellViewModel {
    var cityName: String {get}
    var aqiValue: String {get}
    var timeText: String {get}
    var bgColor: UIColor? {get}
    var category: String {get}
}


extension AQICityModel: AQITableViewCellViewModel {
    var cityName: String {
        return city
    }
    
    var aqiValue: String {
        return String(format: "%.2f", aqi)
    }
    
    var timeText: String {
        let difference = Date.timeDifference(time1: time, time2: Date() )
        if difference < 60 {
            return "A few seconds ago"
        } else if difference > 60 && difference < 120 {
            return "A minute ago"
        } else {
            return time.string(with: DateFormatter.time12period)
        }
    }
    
    var category: String {
        let quality = AQICategoryConfiguration(rawValue: Int(aqi))
        return quality?.displayString ?? ""
    }
    
    var bgColor: UIColor? {
        let quality = AQICategoryConfiguration(rawValue: Int(aqi))
        return quality?.color
    }
}
