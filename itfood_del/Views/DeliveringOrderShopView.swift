//
//  DeliveringOrderShopView.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/3/9.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI

struct DeliveringOrderShopView: View {
    @State var order: Order
    var presentButton: Bool
    @ObservedObject var viewService: ViewService
    @State private var showCompleteOrderAlert = false
    @State private var showCompleteOrderSheet = false
    @State private var showAcceptSuccessAlert = false
    @State private var showAcceptFailureAlert = false
//    @State private var selectedOrder: Order
    
    var body: some View {
        VStack {
            HStack{
                Text("訂單編號")
                    .bold()
                    .font(.footnote)
                    .padding(4)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                Text(order.order_id.description)
                Spacer()
                Text("狀態")
                    .bold()
                    .font(.footnote)
                    .padding(4)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                if presentButton {
                    Text("餐點製作完成")
                } else {
                    Text("餐點製作中")
                }
                Spacer()
            }.padding(.leading)
                .padding(.trailing)
                .padding(.top)
            Divider()
            HStack {
                Text("目的地")
                    .bold()
                    .font(.footnote)
                    .padding(4)
                    .background(Color.red)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                Spacer()
                VStack{
                    Text(order.shop.name)
                        .bold()
                        .font(.caption)
                        .padding(.bottom, 4)
                        .foregroundColor(.secondary)
                    Text(order.shop.address)
                }
                Spacer()
            }.padding(.trailing)
                .padding(.leading)
                .padding(.bottom, 4)
                .padding(.top, 4)
                .padding(.bottom, 4)
                .alert(isPresented: $viewService.showAcceptSuccessAlert) {
                        Alert(title: Text("收餐成功！"))
                }
                
            
            if presentButton {
                Divider()
                HStack{
                    Text("確認取餐")
                        .frame(maxWidth: .infinity)
                        .padding(6)
                        .padding(.top, 4)
                        .padding(.bottom, 4)
                        .background(Color.colorSecondary)
                        .foregroundColor(.colorTextOnS)
                        .cornerRadius(8)
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom, 4)
                        .onTapGesture {
//                            self.selectedOrder = self.order
                            self.showCompleteOrderAlert = true
                    }
                }
            }
        }.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.3), lineWidth: 2))
            .alert(isPresented: self.$showCompleteOrderAlert) {
                var orderDetails: String = ""
                for orderDetail: OrderDetail in self.order.orderDetails! {
                    orderDetails.append("\n" + orderDetail.dish.name + " x" + orderDetail.od_count.description + "\n")
                }
                return Alert(title: Text("確認餐點"), message: Text(orderDetails), primaryButton: .default(Text("確認"), action: {
                    self.viewService.objectWillChange.send()
                    self.viewService.showQRCodeSheet = true
                }), secondaryButton: .cancel())
        }
        .sheet(isPresented: $viewService.showQRCodeSheet) {
            OrderQRCodeView(order: self.order, viewService: self.viewService)
        }
        
    }
}

struct OrderQRCodeView: View {
    @State var order: Order
    var encoder = JSONEncoder()
    @State var uiImage: UIImage?
    let ciContext = CIContext()
    @ObservedObject var viewService: ViewService
    var order_id: String {
        order.order_id.description
    }
    @State private var del_name: String?
    @State private var acceptanceType: String?
    @State private var acceptanceName: String?
    
    func setData(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        if let data = try? encoder.encode(order.order_id) {
            print("ORDER QR CODE: " + (String(data: data, encoding: .utf8) ?? ""))
            guard let ciFilter = CIFilter(name: "CIQRCodeGenerator") else {return}
            ciFilter.setValue(data, forKey: "inputMessage")
            guard let ciImage_smallQR = ciFilter.outputImage else {return}
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            let ciImage_largeQR = ciImage_smallQR.transformed(by: transform)
            let cgImage = self.ciContext.createCGImage(ciImage_largeQR, from: ciImage_largeQR.extent)
            self.uiImage = UIImage(cgImage: cgImage!)
            
            if order.order_state == 2 {
                acceptanceType = "店家"
                acceptanceName = order.shop.name
            } else if order.order_state == 3 {
                acceptanceType = "訂購人"
                acceptanceName = order.order_name
            }
        }
        
    }
    
    
    var body : some View {
        VStack{
            Spacer()
            VStack {
                HStack{
                    Text("訂單編號")
                        .bold()
                        .padding(4)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(4)
                        .padding(.trailing, 4)
                    Text(order_id)
                        .bold()
                }.padding(.bottom, 4)
                HStack {
                    Text(acceptanceType ?? "")
                        .bold()
                        .padding(4)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(4)
                        .padding(.trailing, 4)
                    Text(acceptanceName ?? "")
                        .bold()
                }.padding(.bottom, 4)
                HStack {
                    Spacer()
                Image(uiImage: uiImage ?? UIImage(systemName: "wifi")!)
                .resizable()
                .scaledToFit()
                    Spacer()
                }
            }
            Spacer()
        }.onAppear(perform: setData)
            
        
        
    }
    
    
}
