//
//  DeliveryView.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/2/24.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI
import MapKit


struct DeliveryView: View {
    @EnvironmentObject var userData: UserData
    @State var selectedIndex : Int
    @State var isOnline: Bool = false
    
    
    var orderTypes = ["待接單", "送餐中"]
    var body: some View {
        
        VStack {
            ZStack {
                MapView(followUser: userData.followUser).edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            self.userData.followUser = true
                        }) {
                            Image(systemName: "location")
                        }.padding()
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .font(.headline)
                            .clipShape(Circle())
                            .padding(.trailing)
                            .padding(.bottom)
                    }
                }
            }
            
            VStack{
                Toggle(isOn: $isOnline) {
                    Text("上線：")
                }
                
                Picker("訂單種類", selection: $selectedIndex) {
                    ForEach(0 ..< orderTypes.count){ index in
                        Text(self.orderTypes[index])
                            .tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(4)
                
                /*
                 將訂單藉由 Picker 依分類由不同 List 顯示
                 */
                
                
                
                
                List {
                    ForEach(userData.sortedOrdersArray[selectedIndex], id: \.order_id){ order in
                        OrderItemView(order: order)
                    }
                    
                }.listStyle(DefaultListStyle())
                    .frame(width: nil, height: 200, alignment: .top)
                
            }.cornerRadius(16)
            
        }.edgesIgnoringSafeArea(.all)
            .offset(x: 0, y: -8)

    }
    
   
    
}
