//
//  PersonView.swift
//  itfood_del
//
//  Created by Chi Tang Sun on 2020/3/5.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI

struct PersonView: View {
	//	@Environment(\.presentationMode) var presentationMode
	@ObservedObject var viewService = ViewService()
	@EnvironmentObject var userData: UserData
	
	
	var body: some View {
		NavigationView {
			List{
				NavigationLink(destination: PersonInfoView()) {
					HStack {
						Image("personicon")
						Text("個人資料")
							.font(.body)
							.foregroundColor(Color.orange)
					}
				}
				NavigationLink(destination: PasswordView()) {
					HStack {
						Image("lock")
						Text("修改密碼")
							.font(.body)
							.foregroundColor(Color.orange)
					}
				}
				NavigationLink(destination: InformationView()) {
					HStack {
						Image("question")
						Text("相關資訊")
							.font(.body)
							.foregroundColor(Color.orange)
					}
				}
				NavigationLink(destination: AboutView()) {
					HStack {
						Image("about")
						Text("關於我們")
							.font(.body)
							.foregroundColor(Color.orange)
					}
				}
					HStack {
						Image("personicon")
						Text("登出")
							.font(.body)
							.foregroundColor(Color.orange)
							
						
						
						/*UserDefaults.standard.set(0, forKey: "del_id")
						UserDefaults.standard.set(0, forKey: "areaCode")
						self.userData.del_id = 0
						self.loginSuccessful == false*/
					}.onTapGesture {
							UserDefaults.standard.set(0, forKey: "del_id")
							UserDefaults.standard.set(0, forKey: "areaCode")
							self.userData.del_id = 0
							(UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.toLoginView()
							//							self.presentationMode.wrappedValue.dismiss()
					}.animation(.default)
				
			}
			.navigationBarTitle("個人資訊")
		}
	}
}

//struct PersonView_Previews: PreviewProvider {
//    static var previews: some View {
//        PersonView(loginSuccessful: true)
//    }
//}
