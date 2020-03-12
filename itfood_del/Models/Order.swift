//
//  Order.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/2/24.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import Foundation


//let ipAddress: String = "172.20.10.2"
let ipAddress: String = "127.0.0.1"
//let ipAddress: String = "192.168.43.134"
let url = "http://\(ipAddress)/Itfood_Web/del"



struct OrderMessage : Codable {
    var order : Order
    var receiver: String
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

    var isExpanded: Bool?


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
    case OrderSocket
    case DeliverySocket

    func getURL() -> String {
        switch self {
        case .Order:
            return "http://\(ipAddress):8080/Itfood_Web/OrderServlet"
        case .Shop:
            return  "http://\(ipAddress):8080/Itfood_Web/ShopServlet"
        case .Delivery:
            return  "http://\(ipAddress):8080/Itfood_Web/DeliveryServlet"
        case .OrderDetail:
            return  "http://\(ipAddress):8080/Itfood_Web/OrderDetailServlet"
        case .Member:
            return  "http://\(ipAddress):8080/Itfood_Web/MemberServlet"
        case .OrderSocket:
            return "ws://\(ipAddress):8080/Itfood_Web/OrderSocket/del"
        case .DeliverySocket:
            return "ws://\(ipAddress):8080/Itfood_Web/DeliverySocket/del"
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
