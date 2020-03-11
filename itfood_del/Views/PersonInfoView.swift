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
    
    let url = URL(string: common_url + "DeliveryServlet")
    var person: Person!
    
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
            .onAppear(perform: showData)
        }
    }
    
    func showData() {
        guard let url = url else {
            return
        }
        
        print(id)
        let requestParam = ["action" : "getDataById", "id" : id, "type" : "delivery", "state" : 4, "containDay" : false] as [String : Any]
        executeTask(url, requestParam) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode([Order].self, from: data)
//                    self.orders = result
//                    self.calData()
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
