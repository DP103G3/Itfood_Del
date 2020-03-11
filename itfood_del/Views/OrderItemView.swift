//
//  OrderItemView.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/2/25.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

public struct OrderItemView: View {
    @EnvironmentObject private var locationManager : LocationManager
    @EnvironmentObject var orderItemViewModel : OrderItemViewModel
    @State private var distance : String = "n"
    @State private var distanceUnit : String = "m"
    
    @ObservedObject var viewService: ViewService
    
   var order : Order
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    public var body: some View {
        
        Group {
            // MARK: 待接單訂單
            if order.del_id == -1 && (order.order_state == 1 || order.order_state == 2) {
                QueueingOrderView(viewService: viewService, order: order)
                    .animation(.spring())
                    .onDisappear{
//                        self.orderItemViewModel.queueingItemViewExpanded.removeAll()
                        self.orderItemViewModel.selectedOrder["selected"] = false
//                        self.orderItemViewModel.selectedOrder.removeAll()
                }
                .onTapGesture {
                    self.orderItemViewModel.queueingItemViewExpanded.forEach { (order_id, isExpanded) in
                        if !(order_id == self.order.order_id) {
                            self.orderItemViewModel.queueingItemViewExpanded[order_id] = false
                        }
                        self.orderItemViewModel.selectedOrder["selected"] = false
                    }
                    
                    self.orderItemViewModel
                        .queueingItemViewExpanded[self.order.order_id]?.toggle()
                    
                    if self.orderItemViewModel
                        .queueingItemViewExpanded[self.order.order_id] ?? false {
                        self.orderItemViewModel
                            .selectedOrder["order"] = self.order
                        self.orderItemViewModel
                            .selectedOrder["selected"] = true
                        self.orderItemViewModel
                            .selectedOrder["status"] = "queueing"
                    } else {
                        self.orderItemViewModel
                            .selectedOrder["selected"] = false
                    }
                }
            } else {
                DeliveringOrderView(viewService: viewService, order_state: order.order_state, order: order)
            }
        }.onAppear(perform: addOrderExpanded)
    }
    
    func addOrderExpanded() {
        orderItemViewModel.queueingItemViewExpanded[order.order_id] = false
    }
    
    func getDistance(){
        let originateCoordinate = CLLocation(latitude: order.shop.latitude, longitude: order.shop.longitude)
        let destinationCoordinate = CLLocation(latitude: Double(userLatitude)!, longitude: Double(userLongitude)!)
        let distance = originateCoordinate.distance(from: destinationCoordinate)
        if distance > 1000 {
            self.distance = (distance / 1000).roundToDecimal(1).description
            self.distanceUnit = "公里"
        } else {
            self.distance = Int(distance).description
            self.distanceUnit = "公尺"
        }
    }
}

struct QueueingOrderView: View {
    @EnvironmentObject private var locationManager : LocationManager
    @EnvironmentObject var orderItemViewModel: OrderItemViewModel
    @State private var distance : String = "n"
    @ObservedObject var viewService : ViewService
    @State private var distanceUnit : String = "m"
    @State private var showAcceptOrderAlert = false
    
    var order : Order
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    var body : some View {
        VStack{
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading){
                        HStack {
                            Text("出發地")
                                .bold()
                                .padding(4)
                                .background(Color.colorRed)
                                .foregroundColor(.white)
                                .font(.caption)
                                .cornerRadius(4)
                            
                            VStack(alignment: .center){
                                Text(order.shop.name)
                                    .foregroundColor(.colorNormalText)
                                    .font(.caption)
                                    .bold()
                                    .padding(4)
                                Text(order.shop.address)
                                    .foregroundColor(.colorNormalText)
                                    .padding(4)
                                    .font(.footnote)
                            }.tag("fromInfo")
                        }
                        
                    }.padding(.bottom, 4)
                    
                    VStack(alignment: .leading){
                        HStack {
                            Text("目的地")
                                .bold()
                                .padding(4)
                                .foregroundColor(.white)
                                .background(Color.green)
                                .font(.caption)
                                .cornerRadius(4)
                            
                            
                            Text(order.address.info)
                                .foregroundColor(.colorNormalText)
                                .font(.footnote)
                                .padding(8)
                            
                        }
                    }
                }
                Spacer()
                VStack(alignment: .center) {
                    Text("距離店家")
                        .padding(.bottom, 6)
                        .foregroundColor(.colorTextOnP)
                    HStack {
                        Text (distance + " " + distanceUnit)
                            .bold()
                            .padding(4)
                            .foregroundColor(.red)
                            .cornerRadius(4)
                    }
                }
                Spacer()
            }.onAppear(perform: getDistance)
            
            if orderItemViewModel.queueingItemViewExpanded[order.order_id] ?? false{
                Text("接單")
                    .bold()
                    .padding(4)
                    .padding(.top, 4)
                    .padding(.bottom, 4)
                    .frame(minWidth: nil, idealWidth: nil, maxWidth: .infinity, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .center)
                    .background(Color.colorSecondary)
                    .foregroundColor(.colorTextOnS)
                    .cornerRadius(4)
                    .font(.subheadline)
                    .padding(.top, 10) 
                    .padding(.bottom, 6)
                    .onTapGesture {
                        self.showAcceptOrderAlert.toggle()
                        //                        self.orderItemViewModel.selectedOrder.removeAll()
                        //                        self.orderItemViewModel.queueingItemViewExpanded.forEach { (order_id, isExpanded) in
                        //                            if !(order_id == self.order.order_id) {
                        //                                self.orderItemViewModel.queueingItemViewExpanded[order_id] = false
                        //                            }
                        //                            self.orderItemViewModel.selectedOrder["selected"] = false
                        //                        }
                }.animation(.linear)
            } else {
                //                orderItemViewModel.selectedOrder["selected"] = false
            }
            
        }.alert(isPresented: $showAcceptOrderAlert) {
            Alert(title: Text("確認接單"), message: Text("你確定要接受此訂單？"), primaryButton: .default(Text("確定"), action: {
                self.viewService.sendAcceptOrderMessage(order: self.order)
            }), secondaryButton: .cancel())
        }
    }
    
    func getDistance(){
        let originateCoordinate = CLLocation(latitude: order.shop.latitude, longitude: order.shop.longitude)
        let destinationCoordinate = CLLocation(latitude: Double(userLatitude)!, longitude: Double(userLongitude)!)
        let distance = originateCoordinate.distance(from: destinationCoordinate)
        if distance > 1000 {
            self.distance = (distance / 1000).roundToDecimal(1).description
            self.distanceUnit = "公里"
        } else {
            self.distance = Int(distance).description
            self.distanceUnit = "公尺"
        }
    }
}

struct DeliveringOrderView: View {
    @EnvironmentObject private var locationManager : LocationManager
    @EnvironmentObject var orderItemViewModel: OrderItemViewModel
    @State private var distance : String = "n"
    @ObservedObject var viewService: ViewService
    var order_state: Int
    @State private var distanceUnit : String = "m"
    @State private var showCompleteOrderAlert = false
    @State private var showCompleteOrderSheet = false
    var order : Order
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    var body: some View {
        
        return Group {
            if order_state == 1 {
                DeliveringOrderShopView(order: order, presentButton: false, viewService: viewService)
                .onTapGesture {
                //                        self.orderItemViewModel.selectedOrder.removeAll()
                                        self.orderItemViewModel.selectedOrder["order"] = self.order
                                        self.orderItemViewModel.selectedOrder["selected"] = true
                                        self.orderItemViewModel.selectedOrder["status"] = "deliveringShop"
                                }
            } else if order_state == 2 {
                DeliveringOrderShopView(order: order, presentButton: true, viewService: viewService)
                .onTapGesture {
                //                        self.orderItemViewModel.selectedOrder.removeAll()
                                        self.orderItemViewModel.selectedOrder["order"] = self.order
                                        self.orderItemViewModel.selectedOrder["selected"] = true
                                        self.orderItemViewModel.selectedOrder["status"] = "deliveringShop"
                                }
            } else if order.order_state == 3 {
                DeliveringOrderMemberView(order: order, viewService: viewService)
                .onTapGesture {
                //                        self.orderItemViewModel.selectedOrder.removeAll()
                                        self.orderItemViewModel.selectedOrder["order"] = self.order
                                        self.orderItemViewModel.selectedOrder["selected"] = true
                                        self.orderItemViewModel.selectedOrder["status"] = "deliveringMember"
                                }
            }
        }
    }
}


extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

//struct OrderItemView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        OrderItemView(order: exampleOrders[0])
//    }
//}


