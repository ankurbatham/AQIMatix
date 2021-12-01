//
//  GraphAQIViewModel.swift
//  AQIAssignment
//
//  Created by Ankur Batham on 24/11/21.
//

import Foundation

class GraphAQIViewModel: AQIViewModel {
    var selectedCity: AQICityModel
    
    init(with city: AQICityModel) {
        self.selectedCity = city
        super.init()
    }
    
    func getSelectedCityData()->AQICityModel? {
        return self.cityData.filter({$0.city == self.selectedCity.city}).first
    }
   
}
