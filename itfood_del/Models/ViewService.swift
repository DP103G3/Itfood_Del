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
    @Published var showQRCodeSheet = false
    @Published var showAcceptSuccessAlert = false
    
    private let TAG = "TAG_ViewService"
    private let service = SocketService()
    private let dateFormatter = DateFormatter()
    private let decoder = JSONDecoder()
    private var cancellableSet: Set<AnyCancellable> = []
    let del_id = UserDefaults.standard.integer(forKey: "del_id")
    
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
                        var count = 0;
                        let textComponents = text.components(separatedBy: "order_state")
                        textComponents.forEach { (string) in
                            print("ORDER\(count): " + string)
                            count += 1
                        }
                        let data = text.data(using: .utf8)
                        do {
                            let orders = try self.decoder.decode([Order].self, from: data!)
                            print(self.TAG + "Orders: " + (orders.debugDescription))
                            let queueingOrders = orders.filter { (order) -> Bool in
                                (order.order_state == 1 || order.order_state == 2) && order.del_id == -1
                            }
                            print(self.TAG + "queueingOrders: " + queueingOrders.debugDescription)
                            let deliveringOrders = orders.filter({ (order) -> Bool in
                                order.order_state == 3 || ((order.order_state == 1 || order.order_state == 2) && (order.del_id == self.del_id))
                            })
                            print(self.TAG + "deliveringOrders: " + deliveringOrders.debugDescription)
                            self.queueingOrders = queueingOrders
                            self.deliveringOrders = deliveringOrders
                        }
                        catch {
                            print("ORDERS DECODING ERROR: " + error.localizedDescription)
                        }
                        do {
                            let deliveryMessage: DeliveryMessage = try self.decoder.decode(DeliveryMessage.self, from: data!)
                            print(self.TAG + "DeliveryMessage: " + (deliveryMessage.action ?? ""))
                            let action = deliveryMessage.action
                            if action == "confirmOrder" {
                                self.objectWillChange.send()
                                self.showQRCodeSheet = false
                                //                                    self.objectWillChange.send()
                                self.showAcceptSuccessAlert = true
                            }
                            let order = deliveryMessage.order
                            for o: Order in self.deliveringOrders {
                                if o.order_id == order?.order_id {
                                    let id = o.order_id
                                    self.deliveringOrders = self.deliveringOrders.filter { (order) -> Bool in
                                        order.order_id != id
                                    }
                                    self.deliveringOrders.append(order!)
                                }
                            }
                        } catch {
                            print("DELIVERYMESSAGE DECODING ERROR: " + error.localizedDescription)
                        }
                        
                    //                                print(orders.description)
                    default:
                        break
                    }
                }
            }
            print("Connect to delivery socket!")
        }
        
        //        service.sendFetchOrdersRequest()
    }
    
    //    private var confirmOrderPublisher: AnyPublisher<Bool, Never> {
    //        $confirmOrder
    //            .debounce(for: 0, scheduler: RunLoop.main)
    //            .removeDuplicates()
    //            .map { confirm in
    //                var showing = false
    //                if confirm {
    //                    showing = false
    //                } else {
    //                    showing = true
    //                }
    //                return showing
    //        }.eraseToAnyPublisher()
    //    }
    
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
    
    func sendCompleteMessage(order: Order) {
        let userDefaults = UserDefaults.standard
        let areaCode = userDefaults.integer(forKey: "areaCode")
        let del_id = userDefaults.integer(forKey: "del_id")
        let deliveryMessage = DeliveryMessage(action: "deliveryCompleteOrder", order: order, areaCode: areaCode, sender: "del" + del_id.description, receiver: "mem" + order.mem_id.description)
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
        
        //        confirmOrderPublisher
        //            .receive(on: RunLoop.main)
        //            .map {
        //                showed in
        //                showed ? true : false
        //        }
        //        .assign(to: \.confirmOrder, on: self)
        //        .store(in: &cancellableSet)
    }
    
}
