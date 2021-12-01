//
//  SocketManager.swift
//  AQIAssignment
//
//  Created by Ankur Batham on 23/11/21.
//

import Foundation

protocol SocketDataSubscriber: NSObject {
    func onReceivedConnection()
    func onReceiveData(_ data: Data)
    func onReceiveError(_ error: Error)
    func onDisConnection(with error: Error)
}

class SocketManager: NSObject, SocketHandlerFactory {
    
    static let shared                                    = SocketManager()
    
    //for suporting multiple viewmodel at the same time
    private var subscribers: [SocketDataSubscriber?]     = []
    

    private override init() {}
    
    public func connectSocketManager() {
        let socketHandler = self.createSocketConnection()
        socketHandler.delegate = self
        socketHandler.connect()
    }
    
    public func subscribe(subscriber: SocketDataSubscriber?) {
        guard subscribers.filter({$0 === subscriber}).first == nil else {
            return
        }
        subscribers.append(subscriber)
    }
    
    public func removeSubscription(subscriber: SocketDataSubscriber) {
        subscribers.removeAll(where: {$0 === subscriber})
    }
}

extension SocketManager: SocketHandlerDelegate {
    func socketDidReciveData(_ data: Data) {
        DispatchQueue.main.async { [weak self] in
            self?.subscribers.forEach({$0?.onReceiveData(data)})
        }
    }
    
    func socketDidConnect() {
        DispatchQueue.main.async { [weak self] in
            self?.subscribers.forEach({$0?.onReceivedConnection()})
        }
    }
    
    func socketDidDisconnect(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.subscribers.forEach({$0?.onDisConnection(with: error)})
        }
    }
    
    func socketReceiveError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.subscribers.forEach({$0?.onReceiveError(error)})
        }
    }
}

