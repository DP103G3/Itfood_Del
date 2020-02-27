//
//  ContentView.swift
//  itfood_del
//
//  Created by 莊宇軒 on 2020/2/20.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI
import CoreData
import CoreLocation

struct ContentView: View {
    @EnvironmentObject var orderList : OrderList
    var locationManager = CLLocationManager()
    init() {
        UITabBar.appearance().barTintColor = UIColor(named: "colorPrimary")
    }
    var body: some View {
        TabView{
            //MARK: 訂單Tab
            OrderView(selectedIndex: 0).tabItem {
                VStack{
                    Image(systemName: "folder")
                    Text("訂單")
                }
            }.tag(1)
            
            //MARK: 結算報表Tab
            Text("Tab Content 2").tabItem {
                VStack {
                    Image(systemName: "calendar")
                    Text("結算報表")
                }
            }.tag(2)
            
            //MARK: 個人資訊Tab
            Text("Tab Content 2").tabItem {
                VStack{
                    Image(systemName: "person")
                    Text("個人資訊")
                }
            }.tag(3)
        }.onAppear(perform: loadOrders)
            .onAppear(perform: showLocationRequest)
        
    }
    
    /*
     進入主頁面時向伺服器請求該外送員的訂單
     */
    func loadOrders(){
            let urlStr = URLs.Order
            if let url = URL(string: urlStr.getURL()){
                let body = ["action": "findByDeliveryId", "del_id": "1"]
                let encoder = JSONEncoder()
                let decoder = JSONDecoder()
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
                decoder.dateDecodingStrategy = .formatted(dateFormat)
                let jsonData = try? encoder.encode(body)
                var request = URLRequest(url: url)
                request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
                request.httpBody = jsonData
                request.httpMethod = "POST"
                
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let data = data{
                        //                    let json = String(data: data, encoding: String.Encoding.utf8)
                        //                    print(json!)
                        do {
                            let decodeJson = try decoder.decode([Order].self, from: data)
                            if !decodeJson.isEmpty {
                                DispatchQueue.main.async {
//                                    self.orderList.objectWillChange.send()
                                    self.orderList.orders = decodeJson
                                    self.sortOrders()
                                    
    //                                print(decodeJson)
                                }
                                return
                            }
                        } catch {
                            print(error)
                        }
                    }
                    
                    print ("Fetch Failed: \(error?.localizedDescription ?? "Unknown Error")")
                }.resume()
            }
        }
    
        /*
     將訂單分類為三類：
        queueingOrders : 待接單 （製作中 / 製作完成）
        deliveringOrders : 外送中
        completedOrders : 已完成 （已完成 / 已取消）
     */
        func sortOrders() {
            let orders = orderList.orders
            let queueingOrders = orders.filter { (order) -> Bool in
                order.order_state == 1 || order.order_state == 2
            }
            let deliveringOrders = orders.filter({ (order) -> Bool in
                order.order_state == 3
            })
            let completedOrders = orders.filter({ (order) -> Bool in
                order.order_state == 4 || order.order_state == 5
            })
//            self.orderList.objectWillChange.send()
            orderList.sortedOrdersArray[0] = queueingOrders
            orderList.sortedOrdersArray[1] = deliveringOrders
            orderList.sortedOrdersArray[2] = completedOrders
        }
    func showLocationRequest () {
        locationManager.requestWhenInUseAuthorization()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


