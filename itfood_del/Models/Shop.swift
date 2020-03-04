//
//  Shop.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/2/24.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import Foundation

struct Shop : Codable, Hashable{
    let id : Int
    let name : String
    let phone : String?
    let address : String
    let latitude : Double
    let longitude : Double
    let area : Int?
}
