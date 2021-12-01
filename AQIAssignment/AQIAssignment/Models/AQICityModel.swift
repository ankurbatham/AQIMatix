//
//  AQICityModel.swift
//  AQIAssignment
//
//  Created by Ankur Batham on 23/11/21.
//

import Foundation
struct AQICityModel : Codable {
    let city : String
    let aqi : Double
    enum CodingKeys: String, CodingKey {
        case city
        case aqi
    }
    let time = Date() //using that for showing time when get the data
}

extension AQICityModel: Equatable {
    static func == (lhs: AQICityModel, rhs: AQICityModel) -> Bool {
        return lhs.city == rhs.city
    }
}

extension AQICityModel: Comparable {
    static func < (lhs: AQICityModel, rhs: AQICityModel) -> Bool {
        return lhs.city < rhs.city
    }
}
