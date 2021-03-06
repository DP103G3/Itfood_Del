//
//  AboutView.swift
//  itfood_del
//
//  Created by Chi Tang Sun on 2020/3/5.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    
    var body: some View {
        ZStack {
            Color.colorBackground
            ScrollView{
                VStack{
                    Image("logo").resizable().scaledToFill().frame(width: 280, height: 80, alignment: .center)
                    Text("DP103 G3")
                        .font(.largeTitle)
                        .foregroundColor(Color.colorTextOnP)
                    Text("組長：莊宇軒")
                        .foregroundColor(Color.colorNormalText)
                        .padding(10)
                    Text("組員：徐承維、孫啟唐、周宗佑")
                        .foregroundColor(Color.colorNormalText)
                        .padding(10)
                    Text("")
                        .padding(20)
                    Text("技術支援")
                        .font(.largeTitle)
                        .foregroundColor(Color.colorTextOnP)
                    Text("黃彬華老師、何思慧老師、彼得潘老師")
                        .padding(10)
                        .foregroundColor(Color.colorNormalText)
                    Text("陳本奇老師、張互賓老師、郭惠民老師")
                        .padding(10)
                        .foregroundColor(Color.colorNormalText)
                    Spacer()
                }
                .navigationBarTitle("關於我們")
                .offset(CGSize(width: 0, height: 16))
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
