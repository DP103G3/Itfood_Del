//
//  PersonInfoView.swift
//  itfood_del
//
//  Created by Chi Tang Sun on 2020/3/5.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI

struct PersonInfoView: View {
    let id = UserDefaults.standard.integer(forKey: "del_id")
    @State private var email = ""
    @State private var name = ""
    @State private var identityid = ""
    @State private var phone = ""
    @State private var jointime = ""
    
    let url = URL(string: common_url + "/DeliveryServlet")
    var person: Person!
    
    var body: some View {
        
        //let id:Int UserDefaults.standard.object(forKey: "del_id")
        ScrollView{
            VStack{
                HStack{
                    Text("外送員編號：")
                        .foregroundColor(Color.colorTextOnP)
                    Text(String(id)).foregroundColor(.colorTextOnP)
                    Spacer()
                }.padding(20)
                HStack{
                    Text("加入日期：")
                        .foregroundColor(Color.colorTextOnP)
                    Text("    "+String(jointime)).foregroundColor(.colorTextOnP)
                    Spacer()
                }.padding(20)
                HStack{
                    Text("外送員帳號：")
                        .foregroundColor(Color.colorTextOnP)
                    Text(email).foregroundColor(.colorTextOnP)
                    Spacer()
                }.padding(20)
                HStack{
                    Text("外送員姓名：")
                    .foregroundColor(Color.colorTextOnP)
                    Text(name).foregroundColor(.colorTextOnP)
                    Spacer()
                }.padding(20)
                HStack{
                    Text("身分證字號：")
                    .foregroundColor(Color.colorTextOnP)
                    Text(identityid).foregroundColor(.colorTextOnP)
                    Spacer()
                }.padding(20)
                HStack{
                    Text("外送員電話：")
                    .foregroundColor(Color.colorTextOnP)
                    Text(phone).foregroundColor(.colorTextOnP)
                    Spacer()
                }.padding(20)
                Text("").padding(20)
                NavigationLink(destination: PersonInfoUpdateView()) {
                    VStack {
                        Text("修改資料")
                            .font(.body)
                            .foregroundColor(Color.colorTextOnS)
                            .padding(8)
                            .background(Color.colorSecondary.cornerRadius(4))
                    }
                }
                Spacer()
            }
            .navigationBarTitle("個人資料")
        }.onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear(perform: showData)
        .background(Color.colorBackground)
    }
    
    func showData() {
        guard let url = url else {
            return
        }
        let requestParam = ["action": "findById", "del_id": id] as [String : Any]
        executeTask(url, requestParam) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let data = data {
                do {
                    let person = try JSONDecoder().decode(Person.self, from: data)
                    self.email = person.del_email
                    self.name = person.del_name
                    self.identityid = person.del_identityid
                    self.phone = person.del_phone!
                    self.jointime = person.del_jointime!
                } catch {
                    print(error)
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
