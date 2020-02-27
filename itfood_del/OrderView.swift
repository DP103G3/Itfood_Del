//
//  OrderView.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/2/24.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI
import MapKit


struct OrderView: View {
    @EnvironmentObject var orderList : OrderList
    @State var selectedIndex : Int
    var orderTypes = ["待接單", "送餐中", "已完成"]
    var body: some View {
        NavigationView{
            VStack{
                
                Picker("訂單種類", selection: $selectedIndex) {
                    ForEach(0 ..< orderTypes.count){ index in
                        Text(self.orderTypes[index])
                            .tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                /*
                 將訂單藉由 Picker 依分類由不同 List 顯示
                 */
                
                List {
                    ForEach(orderList.sortedOrdersArray[selectedIndex], id: \.order_id){ order in
                        OrderItemView(order: order)
                    }
                    
                }.listStyle(DefaultListStyle())
                
            }
            .navigationBarTitle(Text("我的訂單"))
        }
        
    }
   
    
    
}
