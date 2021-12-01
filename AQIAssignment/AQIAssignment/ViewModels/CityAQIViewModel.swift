//
//  CityAQIViewModel.swift
//  AQIAssignment
//
//  Created by Ankur Batham on 24/11/21.
//

import Foundation

class CityAQIViewModel: AQIViewModel {
    
    func numberOfSection() -> Int {
        return 1
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        return cityData.count
    }
}
