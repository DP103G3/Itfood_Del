//
//  DeliveringOrderMemberView.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/3/9.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI
import CodeScanner

struct DeliveringOrderMemberView: View {
    var order: Order
    @ObservedObject var viewService: ViewService
    @State private var showCompleteOrderAlert = false
    @State private var orderString: String?
    
    var body: some View {
        VStack {
            HStack{
                Text("訂單編號")
                    .bold()
                    .font(.footnote)
                    .padding(4)
                    .background(Color.colorPrimary)
                    .foregroundColor(.colorTextOnP)
                    .cornerRadius(8)
                Text(order.order_id.description)
                    .foregroundColor(.colorNormalText)
                Spacer()
                Text("狀態")
                    .bold()
                    .font(.footnote)
                    .padding(4)
                    .background(Color.colorPrimary)
                    .foregroundColor(.colorTextOnP)
                    .cornerRadius(8)
                Text("餐點外送中")
                    .foregroundColor(.colorNormalText)
                
                Spacer()
            }.padding(.leading)
                .padding(.trailing)
                .padding(.top)
            Divider()
            HStack{
                Text("付款方式")
                    .bold()
                    .font(.footnote)
                    .padding(4)
                    .background(Color.colorPrimary)
                    .foregroundColor(.colorTextOnP)
                    .cornerRadius(8)
                if order.pay_id == 0 {
                    Text("現金")
                        .foregroundColor(.colorNormalText)
                } else {
                    Text("已付款")
                        .foregroundColor(.colorNormalText)
                }
                Spacer()
                
                Text("收餐人")
                    .bold()
                    .font(.footnote)
                    .padding(4)
                    .background(Color.colorPrimary)
                    .foregroundColor(.colorTextOnP)
                    .cornerRadius(8)
                Text(order.order_name)
                    .foregroundColor(.colorNormalText)
                
                Spacer()
            }.padding(.leading)
                .padding(.trailing)
            Divider()
            HStack{
                Text("訂單金額")
                    .bold()
                    .font(.footnote)
                    .padding(4)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                Text("$ " + order.order_ttprice.description)
                Spacer()
            }.padding(.leading)
                .padding(.trailing)
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
                Text(order.address.info)
                    .foregroundColor(.colorNormalText)
                Spacer()
            }.padding(.trailing)
                .padding(.leading)
                .padding(.bottom, 4)
                .padding(.top, 4)
                .padding(.bottom)
            
            //            Divider()
            //            HStack{
            //                Text("完成訂單")
            //                    .frame(maxWidth: .infinity)
            //                    .padding(6)
            //                    .padding(.top, 4)
            //                    .padding(.bottom, 4)
            //                    .background(Color.colorSecondary)
            //                    .foregroundColor(.colorTextOnS)
            //                    .cornerRadius(8)
            //                    .padding(.leading)
            //                    .padding(.trailing)
            //                    .padding(.bottom, 4)
            //                    .onTapGesture {
            //                        self.showCompleteOrderAlert.toggle()
            //                }
            //            }
        }.overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.3), lineWidth: 2))
        .alert(isPresented: self.$showCompleteOrderAlert) {
            var paymentStatus: String?
            if order.pay_id != 0 {
                paymentStatus = "已付款"
            } else {
                paymentStatus = "未付款，收取現金"
            }
            var orderDetails: String = ""
            for orderDetail: OrderDetail in self.order.orderDetails! {
                orderDetails.append("\n" + orderDetail.dish.name + " x" + orderDetail.od_count.description + "\n")
            }
            return Alert(title: Text("完成訂單"), message: Text(orderDetails) + Text("總計: \(order.order_ttprice)\n") + Text("付款狀態: \(paymentStatus!)"), primaryButton: .default(Text("確認"), action: {
            }), secondaryButton: .cancel())
        }
    }
    
    func setData(){
        let encoder = JSONEncoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        encoder.dateEncodingStrategy = .formatted(formatter)
        if let orderData = try? encoder.encode(order) {
            self.orderString = String(data: orderData, encoding: .utf8)
        }
    }
    
}

