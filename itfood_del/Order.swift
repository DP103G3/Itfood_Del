//
//  Order.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/2/24.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import Foundation

let url = "http://10.0.2.2:8080/Itfood_Web/"

class OrderList : ObservableObject {
    @Published var orders : [Order] = []
    @Published var sortedOrdersArray : [[Order]] = [[Order](), [Order](), [Order]()]
    
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

struct Order : Codable, Hashable{
    let order_id : Int
    let del_id : Int
    let mem_id : Int
    let pay_id : Int
    let shop : Shop
    var order_state : Int
    let order_time : Date?
    var order_ideal : Date?
    var order_delivery : Date?
    let address: Address
    let order_name : String
    let order_phone : String
    let order_ttprice : Int
    let order_area : Int
    let order_type : Int
    let orderDetails : [OrderDetail]?
    

    func description () -> String{
        "{id: " + order_id.description + "\nshop_name: " + shop.name + "}\n"
    }
    

}

struct OrderDetail : Codable, Hashable{
    let od_id : Int
    let order_id : Int
    let dish : Dish
    let od_count : Int
    let od_price : Int
    let od_message : String?
}

struct Dish : Codable, Hashable{
    let id : Int
    let name : String
    let price : Int
}

enum URLs : Hashable {
    case Order
    case Shop
    case OrderDetail
    case Member
    case Delivery
    
    func getURL() -> String {
        switch self {
        case .Order:
            return "http://127.0.0.1:8080/Itfood_Web/OrderServlet"
        case .Shop:
            return  "http://127.0.0.1:8080/Itfood_Web/ShopServlet"
        case .Delivery:
            return  "http://127.0.0.1:8080/Itfood_Web/DeliveryServlet"
        case .OrderDetail:
            return  "http://127.0.0.1:8080/Itfood_Web/OrderDetailServlet"
        case .Member:
            return  "http://127.0.0.1:8080/Itfood_Web/MemberServlet"
        }
    }
}
struct Address: Codable,Hashable {
    let id: Int
    let info: String
    let state: Int
    let longitude: Double
    let latitude: Double
}
