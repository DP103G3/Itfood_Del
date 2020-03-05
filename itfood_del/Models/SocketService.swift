//
//  SocketService.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/3/3.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import Foundation
import Network


class SocketService {
    private let urlSession = URLSession.shared
    private var webSocketTask: URLSessionWebSocketTask?
    private let baseURL = URL(string: URLs.DeliverySocket.getURL() + UserDefaults.standard.integer(forKey: "del_id").description)!
    
    func connect(onMessageReceived: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void) {
        stop()
        webSocketTask = urlSession.webSocketTask(with: baseURL)
        webSocketTask!.resume()
        sendPing()
        receiveMessage(completionHandler: onMessageReceived)
        sendFetchOrdersRequest()
    }
    
    func stop() {
        //        webSocketTask = urlSession.webSocketTask(with: baseURL)
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
    }
    
    private func sendPing() {
        //        webSocketTask = urlSession.webSocketTask(with: baseURL)
        webSocketTask?.sendPing { (error) in
            if let error = error {
                print("Sending PING failed: \(error)")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
                self?.sendPing()
            }
        }
    }
    
    private func receiveMessage(completionHandler: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void) {
        //        webSocketTask = urlSession.webSocketTask(with: baseURL)
        webSocketTask?.receive {[weak self] result in
            switch result {
            case .failure(let error):
                print("Error in receiving message: \(error)")
            case .success(_):
                completionHandler(result)
                self?.receiveMessage(completionHandler: completionHandler)
            }
        }
    }
    
    func sendFetchOrdersRequest (){
        let areaCode = UserDefaults.standard.integer(forKey: "areaCode")
        let sender = "del" + UserDefaults.standard.integer(forKey: "del_id").description
        let encoder = JSONEncoder()
        let deliveryMessage = DeliveryMessage(action: "deliveryFetchOrders", order: nil, areaCode: areaCode, sender: sender, receiver: nil)
        var socketMessage : URLSessionWebSocketTask.Message?
        if let message = try? encoder.encode(deliveryMessage), let messageString = String(data: message, encoding: .utf8) {
            socketMessage = URLSessionWebSocketTask.Message.string(messageString)
        } else {
            print("message decode errror")
        }
        webSocketTask?.send(socketMessage!) { error in
            print(error?.localizedDescription)
        }
    }
    
    func sendDeliveryMessage(deliveryMassage: DeliveryMessage) {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        if let messageData = try? encoder.encode(deliveryMassage), let messageString = String(data: messageData, encoding: .utf8) {
            let message = URLSessionWebSocketTask.Message.string(messageString)
            webSocketTask?.send(message) { error in
                print(error?.localizedDescription)
            }
        }
    }
    
    
}
