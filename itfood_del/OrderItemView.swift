//
//  OrderItemView.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/2/25.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

public struct OrderItemView: View {
    var order : Order
    @ObservedObject var locationManager = LocationManager()
    @State var distance : String = "n"
    @State var distanceUnit : String = "m"
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }

    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    public var body: some View {
        Group {
            // MARK: 待接單訂單
            if order.order_state == 1 || order.order_state == 2 {
                NavigationLink(destination: MapView(order: order).edgesIgnoringSafeArea(.all) ){
                    HStack {
                        VStack {
                            VStack(alignment: .leading){
                                HStack {
                                    Text("From: ")
                                        .font(.caption)
                                        .padding(4)
                                    VStack(alignment: .center){
                                        Text(order.shop.name)
                                            .font(.caption)
                                            .bold()
                                            .padding(4)
                                        Text(order.shop.address)
                                            .padding(4)
                                    }.tag("fromInfo")
                                }
                                
                            }
                            Spacer()
                            VStack(alignment: .leading){
                                HStack {
                                    Text("To: ")
                                        .font(.caption)
                                        .padding(4)
                                    
                                    Text(order.address.info)
                                        .padding(4)
                                    
                                }
                            }
                        }
                        Spacer()
                        VStack(alignment: .center) {
                            Text("距離").font(.title)
                                .padding(.bottom, 6)
                            HStack {
                                Text (distance)
                                Text (distanceUnit)
                            }
                        }
                        Spacer()
                    }
                }
            } else if order.order_state == 3 {
                
            }
        }.onAppear(perform: getDistance)
    }
    
    func getDistance(){
        let originateCoordinate = CLLocation(latitude: order.shop.latitude, longitude: order.shop.longitude)
        let destinationCoordinate = CLLocation(latitude: order.address.latitude, longitude: order.address.longitude)
        let distance = originateCoordinate.distance(from: destinationCoordinate)
        if distance > 1000 {
            self.distance = (distance / 1000).roundToDecimal(1).description
            self.distanceUnit = "km"
        } else {
            self.distance = Int(distance).description
            self.distanceUnit = "m"
        }
    }
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

//struct OrderItemView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        OrderItemView(order: exampleOrders[0])
//    }
//}


