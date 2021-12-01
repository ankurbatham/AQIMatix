//
//  AQIViewModel.swift
//  AQIAssignment
//
//  Created by Ankur Batham on 23/11/21.
//

import Foundation


protocol AQIViewModelDelegate: AnyObject {
    func onDataDidupdate()
    func onDataUpdateFailed(error: Error)
}

class AQIViewModel: NSObject {
    weak var delegate: AQIViewModelDelegate?
    
    var cityData: [AQICityModel] = []
        
    override init() {
        super.init()
        SocketManager.shared.subscribe(subscriber: self)
    }
    
    private func presentParsedData(_ citiesDataModel: [AQICityModel]) {
        citiesDataModel.forEach { [weak self] model in
            if let index = self?.cityData.firstIndex(of: model) {
                self?.cityData[index] = model
            }else {
                self?.cityData.append(AQICityModel(city: model.city, aqi: model.aqi))
            }
        }
        delegate?.onDataDidupdate()
    }
    
    deinit {
        SocketManager.shared.removeSubscription(subscriber: self)
    }
}

extension AQIViewModel: SocketDataSubscriber {
    func onReceivedConnection() {
        print("onReceivedConnection")
    }
    
    func onReceiveError(_ error: Error) {
        self.delegate?.onDataUpdateFailed(error: error)
    }
    
    func onDisConnection(with error: Error) {
        self.delegate?.onDataUpdateFailed(error: error)
    }
    
    func onReceiveData(_ data: Data) {
        JSONParser.parse(of: [AQICityModel].self, from: data) { [weak self] result  in
            switch result {
            case .success(let model):
                self?.presentParsedData(model)
            case .failure(let error):
                print(error)
                self?.delegate?.onDataUpdateFailed(error: error)
            }
        }
    }
}
