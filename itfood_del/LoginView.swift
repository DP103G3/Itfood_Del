//
//  LoginView.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/2/27.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userData: UserData
    @State var loginSuccessful : Bool
    
    var body: some View {
        
        return Group {
            /*
             判斷是否有登入，有登入的話就進入主頁面
             */
            if !loginSuccessful {
                Button(action: {
                    UserDefaults.standard.set(1, forKey: "del_id")
                    self.userData.del_id = 1
                    self.loginSuccessful = true
                    
                } ){
                    Text("Login")
                }
            } else {
                ContentView()
                    
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginSuccessful: true)
    }
}
