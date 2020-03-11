//
//  LoginView.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/2/27.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct LoginView: View {
    
    @EnvironmentObject var userData: UserData
    @State var loginSuccessful : Bool = false
    @State var username: String = ""
    @State var password: String = ""
    @State var showLoginError: Bool = false
    @State var errorString: String = ""
    let ERROR: Int = 0
    let OK: Int = 1
    let WRONG_PASSWORD: Int = 2
    let SUSPENDED: Int = 3
    var NOT_FOUND: Int = 4
    var body: some View {
        
        return Group {
            /*
             判斷是否有登入，有登入的話就進入主頁面
             */
            if !loginSuccessful {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(alignment: .center) {
                            VStack {
                                Image("logo")
                                    .resizable().frame(width: 200, height: 90)
                                HStack {
                                    Spacer()
                                    Text("外送員端")
                                        .bold()
                                        .font(.body)
                                        .foregroundColor(Color.colorTextOnP).offset(CGSize(width: 0, height: -20))
                                }
                            }
                            .scaledToFit()
                            .padding(.leading, 40)
                            .padding(.trailing, 40)
                            TextField("Username (Email Address)", text: $username)
                                .padding(.leading, 16)
                                .disableAutocorrection(true)
                                .textContentType(.emailAddress)
                                .frame(width: 300, height: 50, alignment: .center)
                                .background(Color.colorBackground)
                                .cornerRadius(5.0)
                                .foregroundColor(.colorTextOnP)
                                .keyboardType(.emailAddress)
                            SecureField("Password", text: $password)
                                .padding(.leading, 16)
                                .disableAutocorrection(true)
                                .textContentType(.password)
                                .frame(width: 300, height: 50, alignment: .center)
                                .background(Color.colorBackground)
                                .cornerRadius(5.0)
                                .foregroundColor(.colorTextOnP)
                            Button(action: {
                                self.login(email: self.username, password: self.password)
                            }) {
                                Text("登入")
                                    .font(.headline)
                                    .foregroundColor(.colorTextOnS)
                                    .padding()
                                    .frame(width: 220, height: 60)
                                    .background(Color.colorSecondary)
                                    .cornerRadius(15.0)
                            }.offset(CGSize(width: 0, height: 16))
                        }
                        Spacer()
                    }
                    Spacer()
                }.background(Color.colorPrimary)
                    .alert(isPresented: $showLoginError) {
                        Alert(title: Text(errorString))
                }.onAppear(perform: readLoginStatus)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }.edgesIgnoringSafeArea(.all)
                
                
            } else {
                ContentView().animation(.default)
                
            }
        }
    }
    
    func readLoginStatus() {
        let userDefaults = UserDefaults.standard
        let del_id = userDefaults.integer(forKey: "del_id")
        if del_id != 0 {
            self.loginSuccessful = true
        }
    }
    
    func login(email: String, password: String) {
        if let url = URL(string: URLs.Delivery.getURL()) {
            let encoder = JSONEncoder()
            var request: URLRequest = URLRequest(url: url)
            if email.isEmpty {
                self.errorString = "請輸入帳號！"
                self.showLoginError = true
                return
            } else if password.isEmpty {
                self.errorString = "請輸入密碼！"
                self.showLoginError = true
                return
            }
            let loginMessage = LoginMessage(action: "login", del_email: email, del_password: password)
            
            request.httpMethod = "POST"
            if let loginData = try? encoder.encode(loginMessage) {
                request.httpBody = loginData
            }
            
            
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data, let loginResult = try? JSONDecoder().decode(LoginResult.self, from: data){
                    
                    let result = loginResult.result
                    if result != 1 {
                        switch result {
                        case self.ERROR :
                            self.errorString = "伺服器異常，請稍後再試。"
                            self.showLoginError = true
                            return
                        case self.WRONG_PASSWORD:
                            self.errorString = "密碼錯誤！"
                            self.showLoginError = true
                            return
                        case self.NOT_FOUND:
                            self.errorString = "此帳號不存在！請檢查是否輸入正確"
                            self.showLoginError = true
                            return
                        case self.SUSPENDED:
                            self.errorString = "此帳號已被停權！"
                            self.showLoginError = true
                            return
                        default:
                            break
                        }
                        
                    } else {
                        let del_id = loginResult.del_id!
                        let del_area_code = loginResult.del_area!
                        let userDefaults = UserDefaults.standard
                        DispatchQueue.main.async {
                            self.loginSuccessful = true
                            userDefaults.set(del_id, forKey: "del_id")
                            userDefaults.set(del_area_code, forKey: "areaCode")
                            self.userData.del_id = del_id
                        }
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.loginSuccessful = false
                        self.showLoginError = true
                        self.errorString = "伺服器異常，請稍後再試。"
                    }
                }
            }.resume()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginSuccessful: true)
    }
}

struct LoginMessage : Codable {
    let action: String
    let del_email: String
    let del_password: String
}

struct LoginResult: Codable {
    let result: Int
    let del_id: Int?
    let del_area: Int?
}


//Button(action: {
//    UserDefaults.standard.set(1, forKey: "del_id")
//    UserDefaults.standard.set(1, forKey: "areaCode")
//    self.userData.del_id = 1
//    self.loginSuccessful = true
//
//} ){
//    Text("Login")
//}.animation(.default)
