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
                        TextField("舊密碼", text:$obsoletePassword)
                            .border(Color.gray)
                            .padding(20)
                        }.padding(20)
                    VStack{
                        Text("請輸入新密碼：")
                            .foregroundColor(Color.colorTextOnP)
                        TextField("新密碼", text:$newPassword)
                            .border(Color.gray)
                            .padding(20)
                        }.padding(20)
                    VStack{
                        Text("請再輸入一次新密碼：")
                            .foregroundColor(Color.colorTextOnP)
                        TextField("確認新密碼", text:$checkPassword)
                            .border(Color.gray)
                            .padding(20)
                    }.padding(20)
                   
                       
                            VStack {
                                Text("送出")
                                    .font(.body)
                                    .foregroundColor(Color.colorTextOnS)
                                    .padding(8)
                                    .background(Color.colorSecondary.cornerRadius(4))
                            }
                        

                        
//                    Button(action: {
//
//                                   } ){
//                                       Text("送出")
//                                        .font(.body)
//                                        .foregroundColor(Color.colorTextOnS)
//                                        .padding(8)
//                                        .background(Color.colorSecondary.cornerRadius(4))
//                                   }.animation(.default)
                    .padding(20)
                    
                     Spacer()
                } .navigationBarTitle("修改密碼")
            }
        }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView()
    }
}
