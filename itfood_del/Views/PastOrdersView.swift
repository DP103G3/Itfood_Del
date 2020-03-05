//
//  PastOrdersView.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/2/29.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI

struct PastOrdersView: View {
    @EnvironmentObject var userData: UserData
    var body: some View {
        NavigationView{
        List{
            ForEach(userData.sortedOrdersArray[2], id: \.order_id) { order in
                Text(order.order_id.description)
            }
        
        }.navigationBarTitle("過去訂單")
        }
    }
}

struct PastOrdersView_Previews: PreviewProvider {
    static var previews: some View {
        PastOrdersView()
    }
}
