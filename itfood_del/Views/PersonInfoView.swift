//
//  PersonInfoView.swift
//  itfood_del
//
//  Created by Chi Tang Sun on 2020/3/5.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI

struct PersonInfoView: View {
    @EnvironmentObject var userData: UserData
    @State private var id = ""
    @State private var name = ""
    @State private var identityid = ""
    @State private var phone = ""
    
    let url_server = URL(string: common_url + "DeliveryServlet")
    var person: Person!
    func viewWillAppear(){
        self.showData()
    }
    var body: some View {
       
        //let id:Int UserDefaults.standard.object(forKey: "del_id")
        ScrollView{
            VStack{
                HStack{
                    Text("外送員編號：")
                        .foregroundColor(Color.colorTextOnP)
                    TextField("編號", text:$id)
                    Spacer()
                }.padding(20)
                    
                HStack{
                    Text("外送員姓名：")
                    .foregroundColor(Color.colorTextOnP)
                    TextField("姓名", text:$name)
                    Spacer()
                }.padding(20)
                HStack{
                    Text("身分證字號：")
                    .foregroundColor(Color.colorTextOnP)
                    TextField("身分證字號", text:$identityid)
                    Spacer()
                }.padding(20)
                HStack{
                    Text("外送員電話：")
                    .foregroundColor(Color.colorTextOnP)
                    TextField("電話", text:$phone)
                    Spacer()
                }.padding(20)
                Text("")
                    .padding(20)
                 NavigationLink(destination: PersonInfoUpdateView()) {
                    HStack {
                        
                        Text("修改資料")
                            .font(.body)
                            .foregroundColor(Color.orange)
                                      }
                    }
             Spacer()
            }
            .navigationBarTitle("個人資料")
        }
    }
    
    func showData(){
        let requestParam = ["action" : "getDataById","del_id" : id]
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
            if data != nil {
                // 將輸入資料列印出來除錯用
                print("input: \(String(data: data!, encoding: .utf8)!)")
                }
            }
        }
    }
}

struct PersonInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PersonInfoView()
    }
}
