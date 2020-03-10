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
    //    @EnvironmentObject var userData: UserData
    @ObservedObject var viewService = ViewService()
    @EnvironmentObject var orderItemViewModel: OrderItemViewModel
    @State var selectedIndex : Int
    @State var followUser: Int = 0
    
    var orderTypes = ["待接單", "送餐中"]
    var body: some View {
        return VStack {
            ZStack {
                MapView(followUser: followUser, selectedOrder: orderItemViewModel.selectedOrder).edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            self.followUser += 1
                            
                            //clear all expanded order item views
                            self.orderItemViewModel.queueingItemViewExpanded.forEach { (key,  value) in
                                self.orderItemViewModel.queueingItemViewExpanded[key] = false
                            }
                            
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
                Toggle(isOn: $viewService.connectToSocket.animation(.spring())) {
                    if viewService.connectToSocket {
                        Text("上線")
                            .padding(2)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    } else {
                        Text("離線")
                            .padding(2)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
                .animation(.spring())
                .padding(4)
                .padding(.leading, 4)
                .padding(.trailing, 4)
                .background(Color.colorPrimary)
                .cornerRadius(4)
                .toggleStyle(SwitchToggleStyle())
                    
                .padding(.trailing, 4)
                .padding(.leading, 4)
                
                
                Picker("訂單種類", selection: $selectedIndex.animation(.spring())) {
                    ForEach(0 ..< orderTypes.count){ index in
                        if index == 0 {
                            (Text(self.orderTypes[0]) +
                                Text(" (" + self.viewService.queueingOrders.count.description + ")"))
                                .transition(.opacity)
                                .animation(.easeInOut(duration:1))
                                .tag(0)
                        } else {
                            (Text(self.orderTypes[1]) +
                                Text(" (" + self.viewService.deliveringOrders.count.description + ")"))
                                .transition(.opacity)
                                .animation(.easeInOut(duration:1))
                            .tag(1)
                        }
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(.trailing, 4)
                    .padding(.leading, 4)
                    
                    
                
                /*
                 將訂單藉由 Picker 依分類由不同 List 顯示
                 */
                List {
                    if selectedIndex == 0 {
                        ForEach(viewService.queueingOrders, id:\.order_id) { order in
                            OrderItemView(viewService: self.viewService, order: order)
                        }.listStyle(DefaultListStyle())
                        
                    } else if selectedIndex == 1 {
                        
                        ForEach(viewService.deliveringOrders, id:\.order_id) { order in
                            OrderItemView(viewService: self.viewService, order: order)
                            
                        }.listStyle(PlainListStyle())
                    }
                }.background(Color.white.opacity(0))
                    .frame(width: nil, height: 280, alignment: .top)
                
            }.offset(x: 0, y: -8)
        }
        
        
        
    }
}
