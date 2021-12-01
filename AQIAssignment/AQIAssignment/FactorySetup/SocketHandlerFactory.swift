//
//  SocketHandlerFactory.swift
//  AQIAssignment
//
//  Created by Ankur Batham on 23/11/21.
//

import Foundation

protocol SocketHandlerFactory {
    func createSocketConnection()->SocketHandler
}

extension SocketHandlerFactory {
    func createSocketConnection()->SocketHandler {
        let socketHandler = SocketHandler(url: URL(string:"ws://city-ws.herokuapp.com")!, timeout: 60)
        return socketHandler
    }
}
