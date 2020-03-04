//
//  AreaOrders.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/3/3.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import Foundation

struct AreaOrders: Codable {
    var orders: [Order]
    var shopUserStrings: [String]
    var deliveryUserStrings: [String]
}
