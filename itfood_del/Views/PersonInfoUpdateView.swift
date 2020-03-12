//
//  PersonInfoUpdateView.swift
//  itfood_del
//
//  Created by Chi Tang Sun on 2020/3/10.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI

struct PersonInfoUpdateView: View {
    let id = UserDefaults.standard.integer(forKey: "del_id")
    @State private var email = ""
    @State private var name = ""
    @State private var identityid = ""
    @State private var phone = ""

    
    @EnvironmentObject var userData: UserData
    @State var updateSuccessful : Bool = false
    @State var showUpdateError: Bool = false
    @State var errorString: String = ""
    let ERROR: Int = 0
    let OK: Int = 1
    let WRONG_PASSWORD: Int = 2
    let SUSPENDED: Int = 3
    var NOT_FOUND: Int = 4
    
   
    let url = URL(string: common_url + "/DeliveryServlet")
    var person: Person!
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Text("外送員姓名：")
                    .foregroundColor(Color.colorTextOnP)
                    TextField("姓名",text: $name).foregroundColor(.colorTextOnP)
                    Spacer()
                }.padding(20)
                HStack{
                    Text("身分證字號：")
                    .foregroundColor(Color.colorTextOnP)
                    TextField("身分證字號",text:$identityid).foregroundColor(.colorTextOnP)
                    Spacer()
                }.padding(20)
                HStack{
                    Text("外送員電話：")
                    .foregroundColor(Color.colorTextOnP)
                    TextField("電話", text: $phone).foregroundColor(.colorTextOnP)
                    Spacer()
                }.padding(20)
                Text("").padding(20)
                    VStack {
                        Text("送出")
                            .font(.body)
                            .foregroundColor(Color.colorTextOnS)
                            .padding(8)
                            .background(Color.colorSecondary.cornerRadius(4))
                    }
//                 Button(action: {
//                    self.send (name:self.name,identityid: self.identityid,phone: self.phone)
//                }) {
//                    Text("送出")
//                        .font(.body)
//                        .foregroundColor(Color.colorTextOnS)
//                        .padding(8)
//                        .background(Color.colorSecondary.cornerRadius(4))
//                }.offset(CGSize(width: 0, height: 16))
            }
            .navigationBarTitle("修改資料")
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
                    self.name = person.del_name
                    self.identityid = person.del_identityid
                    self.phone = person.del_phone!
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func send(name: String, identityid: String, phone: String) {
        if let url = URL(string: URLs.Delivery.getURL()) {
            let encoder = JSONEncoder()
            var request: URLRequest = URLRequest(url: url)
            if name.isEmpty {
                self.errorString = "請輸入姓名！"
                self.showUpdateError = true
                return
            } else if identityid.isEmpty {
                self.errorString = "請輸入身分證號碼！"
                self.showUpdateError = true
                return
            }else if phone.isEmpty {
                self.errorString = "請輸入電話！"
                self.showUpdateError = true
                return
            }
//            let person = try JSONDecoder().decode(Person.self)
//            person.del_name = self.name
//            person.del_identityid = self.identityid
//            person.del_phone! = self.phone
//
//            request.httpMethod = "POST"
//            if let updateData = try? encoder.encode(update) {
//                request.httpBody = updateData
//                executeTask(self.url!, update) { (data, response, error) in
//                               if error == nil {
//                                   if data != nil {
//                                       if let result = String(data: data!, encoding: .utf8) {
//                                           if let count = Int(result) {
//                                               DispatchQueue.main.async {
//                                                   // 新增成功則回前頁
//                                                   if count != 0 {
//                                                       self.navigationController?.popViewController(animated: true)
//                                                   } else {
//                                                       self.label.text = "update fail"
//                                                   }
//                                               }
//                                           }
//                                       }
//                                   }
//                               } else {
//                                   print(error!.localizedDescription)
//                               }
//                           }
//            }

        }
    }
    
}
  

struct PersonInfoUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        PersonInfoUpdateView()
    }
}
    struct Update : Codable {
        let action: String
        let del_name: String
        let del_identityid: String
        let del_phone: String
    }



