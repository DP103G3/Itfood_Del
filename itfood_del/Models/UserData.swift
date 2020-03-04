//
//  UserData.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/3/2.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import Foundation

class UserData : ObservableObject {
    @Published var orders : [Order] = [] {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var sortedOrdersArray : [[Order]] = [[Order](), [Order](), [Order]()] {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var viewTypes : Int? {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var followUser: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var del_id : Int = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var webSocketTask: URLSessionWebSocketTask?
    
    var queueingOrders : [Order] {
        get {
            return orders.filter { (order) -> Bool in
                order.order_state == 1 || order.order_state == 2
            }
        }
    }
    var deliveringOrders : [Order] {
        get {
            return orders.filter { (order) -> Bool in
                order.order_state == 3
            }
        }
    }
    var completedOrders : [Order] {
        get{
            return orders.filter { (order) -> Bool in
                order.order_state == 4 || order.order_state == 5
            }
        }
    }
}
