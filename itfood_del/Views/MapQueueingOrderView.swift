//
//  MapQueueingOrderView.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/2/29.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI

struct MapQueueingOrderView: View {
    var body: some View {
        VStack{
            HStack{
                VStack{
                    HStack{
                        VStack{
                            HStack{
                                Text("出發地")
                                    .bold()
                                    .foregroundColor(Color.white)
                                    .padding(6)
                                    .background(Color.red)
                                    .cornerRadius(12)
                                    .padding()
                                
                                Spacer()
                                
                                Text("店家名稱")
                                Spacer()
                            }
                            
                            HStack{
                                Text("目的地")
                                    .bold()
                                    .foregroundColor(Color.white)
                                    .padding(6)
                                    .background(Color.green)
                                    .cornerRadius(12)
                                    .padding()
                                Spacer()
                                Text("桃園市中壢區忠大陸")
                                Spacer()
                            }.padding(.bottom, 8)
                        }
                        VStack{
                            
                            Text("距離")
                                .font(.headline)
                                .padding()
                            Text("321 km")
                                .font(.subheadline)
                            .padding()
                            
                        }
                    }
                    Button(action: {
                        print("HI")
                    }) {
                        Spacer()
                        Text("接單")
                            .bold()
                            .font(.title)
                        Spacer()
                        
                    }.padding()
                        .foregroundColor(Color.colorTextOnS)
                        .background(Color.colorSecondary)
                        .cornerRadius(12)
                }.padding()
            }
        }
    }
}

struct MapQueueingOrderView_Previews: PreviewProvider {
    static var previews: some View {
        MapQueueingOrderView()
    }
}
