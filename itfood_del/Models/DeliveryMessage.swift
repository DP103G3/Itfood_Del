//
//  DeliveryMessage.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/3/3.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import Foundation

struct DeliveryMessage: Codable {
    var action: String?
    var order: Order?
    var areaCode: Int?
    var sender: String?
    var receiver: String?
}
