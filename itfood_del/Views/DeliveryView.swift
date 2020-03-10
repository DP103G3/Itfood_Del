//
//  DeliveryView.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/2/24.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI
import MapKit
import CodeScanner


struct DeliveryView: View {
    //    @EnvironmentObject var userData: UserData
    @ObservedObject var viewService = ViewService()
    @EnvironmentObject var orderItemViewModel: OrderItemViewModel
    @State var selectedIndex : Int
    @State var followUser: Int = 0
    @State var showCompleteOrderSheet = false
    @State var showLoginAlert = false
    
    var orderTypes = ["待接單", "送餐中"]
    var body: some View {
        return VStack {
            ZStack {
                MapView(followUser: followUser, selectedOrder: orderItemViewModel.selectedOrder).edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Button(action: {
                            if self.viewService.connectToSocket {
                                self.showCompleteOrderSheet = true
                            } else {
                                self.showLoginAlert = true
                            }
                            
                        }) {
                            Image(systemName: "qrcode.viewfinder")
                            .resizable()
                                .frame(width: 24, height: 24)
                            .scaledToFit()
                        }.padding(6)
                            .background(Color.colorSecondary)
                            .foregroundColor(.colorTextOnS)
                            .font(.headline)
                            .clipShape(Rectangle())
                            .cornerRadius(8)
                            .padding(.leading)
                        Spacer()
                    }
                    Spacer()
                }
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
        }.sheet(isPresented: $showCompleteOrderSheet) {
                    CodeScannerView(codeTypes: [.qr], completion: self.handleScan)
        //            CodeScannerView(codeTypes: [.qr], simulatedData: self.orderString ?? "", completion: self.handleScan)
                }
        .alert(isPresented: self.$showLoginAlert){
            Alert(title: Text("請先上線！"))
        }
        
        
        
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.showCompleteOrderSheet = false
        switch result {
        case .success(let code):
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(formatter)
            if let data = code.data(using: .utf8), let order_id = try? decoder.decode(Int.self, from: data) {
                let orders = self.viewService.deliveringOrders.filter { (order) -> Bool in
                    order.order_id == order_id
                }
                
                
                guard !orders.isEmpty else {
                    print("Order doesn't match.")
                    return
                }
                print("Scanned success")
                let order = orders[0]
                self.viewService.sendCompleteMessage(order: order)
                return
            }
        case .failure(let error):
            print("Scanning failed" + error.localizedDescription)
        }
    }
}
