//
//  SocketHandler.swift
//  AQIAssignment
//
//  Created by Ankur Batham on 23/11/21.
//

import Foundation

protocol SocketHandlerDelegate: AnyObject {
    func socketDidReciveData(_ data: Data)
    func socketDidConnect()
    func socketDidDisconnect(_ error: Error)
    func socketReceiveError(_ error: Error)
}

class SocketHandler: NSObject {
    
    private var socket                      : URLSessionWebSocketTask!
    private var timeout                     : TimeInterval!
    private var url                         : URL!
    private(set) var isConnected            : Bool                       = false
    
    weak var delegate                       : SocketHandlerDelegate?
    
    init(url:URL,timeout:TimeInterval) {
        self.timeout        = timeout
        self.url            = url
        super.init()
    }
    
    public func connect() {
        let configuration                        = URLSessionConfiguration.default
        let urlSession                           = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue())
        let urlRequest                           = URLRequest(url: url,timeoutInterval: timeout)
        socket                                   = urlSession.webSocketTask(with: urlRequest)
        socket.resume()
        readMessage()
    }
    
    private func readMessage() {
        socket.receive { result in
            switch result {
            case .failure(_):
                break
            case .success(let message):
                switch message {
                case .data(let data):
                    self.delegate?.socketDidReciveData(data)
                case .string(let string):
                    print(string)
                    if let data = string.data(using: String.Encoding.utf8) {
                        self.delegate?.socketDidReciveData(data)
                    }
                @unknown default:
                    print("un implemented case found in SocketHandler")
                }
                self.readMessage()
            }
        }
    }
    
    func closeConnection() {
        socket.cancel(with: .goingAway, reason: nil)
    }
}

extension SocketHandler: URLSessionDelegate , URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        isConnected = true
        print("Socket Connected")
        delegate?.socketDidConnect()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        isConnected = false
        print("Socket close")
    }
    
    ///never call delegate?.webSocketDidDisconnect in this method it leads to close next connection
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            handleError(error)
        }
    }
        
    /// we need to check if error code is one of the 57 , 60 , 54 timeout no network and internet offline to notify delegate we disconnected from internet
    private func handleError(_ error:Error?){
        if let error = error as NSError?{
            if error.code == 57  || error.code == 60 || error.code == 54{
                isConnected = false
                closeConnection()
                delegate?.socketDidDisconnect(error)
                
            }else{
                delegate?.socketReceiveError(error)
                
            }
        }
    }
}
