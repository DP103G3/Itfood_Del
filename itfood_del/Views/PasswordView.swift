//
//  PasswordView.swift
//  itfood_del
//
//  Created by Chi Tang Sun on 2020/3/5.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI

struct PasswordView: View {
   // var password :String
    @State private var obsoletePassword = ""
    @State private var newPassword = ""
     @State private var checkPassword = ""
    
    var body: some View {
        ZStack {
            Color.colorBackground
            ScrollView{
                VStack{
                    VStack{
                        Text("請輸入舊密碼：")
                            .foregroundColor(Color.colorTextOnP)
                        SecureField("舊密碼", text:$obsoletePassword)
                            .frame(width: 300, height: 50, alignment: .center)
                            .padding(.horizontal, 16)
                            .foregroundColor(.colorTextOnP)
                            .background(Color.colorItemBackground)
                            .cornerRadius(5.0)
                        }.padding(20)
                    VStack{
                        Text("請輸入新密碼：")
                            .foregroundColor(Color.colorTextOnP)
                        SecureField("新密碼", text:$newPassword)
                            .frame(width: 300, height: 50, alignment: .center)
                            .padding(.horizontal, 16)
                            .foregroundColor(.colorTextOnP)
                            .background(Color.colorItemBackground)
                            .cornerRadius(5.0)
                        }.padding(20)
                    VStack{
                        Text("請再輸入一次新密碼：")
                            .foregroundColor(Color.colorTextOnP)
                        SecureField("確認新密碼", text:$checkPassword)
                            .frame(width: 300, height: 50, alignment: .center)
                            .padding(.horizontal, 16)
                            .foregroundColor(.colorTextOnP)
                            .background(Color.colorItemBackground)
                            .cornerRadius(5.0)
                    }.padding(20)
                   
                    Button(action: {
                                       
                   } ){
                       Text("送出")
                   }.animation(.default)
                    .padding(8)
                    .background(Color.colorSecondary)
                    .cornerRadius(4)
                     Spacer()
                } .navigationBarTitle("修改密碼")
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView()
    }
}
