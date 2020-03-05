//
//  ViewService.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/3/3.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import Foundation
import Combine

class ViewService: ObservableObject {
    @Published var connectToSocket = false
    @Published var queueingOrders = [Order]()
    @Published var deliveringOrders = [Order]()
    
    private let service = SocketService()
    private let dateFormatter = DateFormatter()
    private let decoder = JSONDecoder()
    private var cancellableSet: Set<AnyCancellable> = []
    
    func connect() {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        service.connect { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("Error in receiving message: \(error)")
                case .success(let message):
                    switch message {
                    case .string(let text):
                        do {
                            print("View service" + " Receiving Message: " + text)
                            let data = text.data(using: .utf8)
                            let areaOrders = try self.decoder.decode(AreaOrders.self, from: data!)
                            print(areaOrders)
                            let orders = areaOrders.orders
                            let queueingOrders = orders.filter { (order) -> Bool in
                                order.order_state == 1 || order.order_state == 2
                            }
                            let deliveringOrders = orders.filter({ (order) -> Bool in
                                order.order_state == 3
                            })
                            self.queueingOrders = queueingOrders
                            self.deliveringOrders = deliveringOrders
                            //                                print(orders.description)
                            
                        } catch  {
                            print(error)
                        }
                    default:
                        break
                    }
                }
            }
            print("Connect to delivery socket!")
        }
        
        //        service.sendFetchOrdersRequest()
    }
    
    private var connectToSocketPublisher: AnyPublisher<Bool, Never> {
        $connectToSocket
            .debounce(for: 0, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { connect in
                var result = false
                if connect {
                    self.connect()
                    result = true
                } else {
                    self.queueingOrders.removeAll()
                    self.deliveringOrders.removeAll()
                    self.service.stop()
                    result = false
                }
                return result
        }.eraseToAnyPublisher()
    }
    
    func sendAcceptOrderMessage(order: Order) {
        let userDefaults = UserDefaults.standard
        let areaCode = userDefaults.integer(forKey: "areaCode")
        let del_id = userDefaults.integer(forKey: "del_id")
        let deliveryMessage = DeliveryMessage(action: "deliveryAcceptOrder", order: order, areaCode: areaCode, sender: "del" + del_id.description, receiver: "shop" + order.shop.id.description)
        service.sendDeliveryMessage(deliveryMassage: deliveryMessage)
    }
    
    init() {
        connectToSocketPublisher
            .receive(on: RunLoop.main)
            .map {
                connected in
                connected ? true : false
        }
        .assign(to: \.connectToSocket, on: self)
        .store(in: &cancellableSet)
    }
    
}
