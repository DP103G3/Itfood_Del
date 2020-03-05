//
//  OrderItemViewModel.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/3/4.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import Foundation
import SwiftUI

class OrderItemViewModel: ObservableObject {
    @Published var queueingItemViewExpanded = [Int: Bool]()
    @Published var selectedOrder = [String: Any]()
    
    init() {
    }
}
