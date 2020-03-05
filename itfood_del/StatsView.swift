//
//  StatsView.swift
//  itfood_del
//
//  Created by 莊宇軒 on 2020/3/2.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI

struct StatsView: View {
    
    let id: Int
    let url = URL(string: common_url + "/OrderServlet")
    @State private var orders = [Order]()
    @State private var amount = 0
    @State private var total = 0
    
    @State private var showDatePicker = false
    @State private var textfieldText = "2020 / Feb"
    @State private var selectYear = Calendar.current.component(.year, from: Date()) - 2010
    @State private var selectMonth = Calendar.current.component(.month, from: Date()) - 2
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
    let yearSorce = (2010...Calendar.current.component(.year, from: Date())).map { (year) -> String in
        return String(year)
    }
    let maxMonth: Int = {
        let calendar = Calendar.current
        let lastMonth = calendar.date(byAdding: .month, value: -1, to: Date())!
        return calendar.component(.month, from: lastMonth)
    }()
    let monthSorce = (1...12).map { (month) -> String in
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.month = month
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            return formatter
        }()
        return formatter.string(from: dateComponents.date!)
    }
    
    func loadData() {
        guard let url = url else {
            return
        }
        let dateMili: Int64 = {
            var components = DateComponents()
            components.calendar = Calendar.current
            components.year = selectYear + 2010
            components.month = selectMonth + 1
            return Int64(components.date!.timeIntervalSince1970 * 1000)
        }()
        print(id)
        let requestParam = ["action" : "findByCase", "id" : id, "type" : "delivery", "state" : 4, "dateMili" : dateMili, "containDay" : false] as [String : Any]
        executeTask(url, requestParam) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(self.dateFormatter)
                    let result = try decoder.decode([Order].self, from: data)
                    self.orders = result
                    self.calData()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func calData() {
        total = orders.map({ (order) -> Int in
            order.order_ttprice
        }).reduce(into: 0, {
            $0 += $1
        })
        amount = orders.count
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("選擇月份", text: $textfieldText, onEditingChanged: { (editting) in
                    self.showDatePicker = editting
                }).padding(20)
            }
            if showDatePicker {
                VStack {
                    Button(action: {
                        self.showDatePicker = false
                        self.loadData()
                        UIApplication.shared.windows.forEach { $0.endEditing(true) }
                    }) {
                        Text("確定")
                    }
                    HStack {
                        Picker(selection: $selectYear, label: Text("年")) {
                            ForEach(0..<yearSorce.count) {
                                Text(self.yearSorce[$0]).tag($0)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width / 2)
                        .onReceive([self.selectYear].publisher.first()) { (selectYear) in
                            self.selectYear = selectYear
                            self.textfieldText = "\(self.yearSorce[self.selectYear]) / \(self.monthSorce[self.selectMonth])"
                            if selectYear == self.yearSorce.count - 1 {
                                self.selectMonth = self.selectMonth > self.maxMonth - 1 ? self.maxMonth - 1 : self.selectMonth
                            }
                        }
                        Picker(selection: $selectMonth, label: Text("月")) {
                            ForEach(0..<self.monthSorce.count, id: \.self) {
                                Text(self.monthSorce[$0]).tag($0)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width / 2)
                        .onReceive([self.selectMonth].publisher.first()) { (selectMonth) in
                            self.selectMonth = selectMonth
                            if self.selectYear == self.yearSorce.count - 1 {
                                self.selectMonth = self.selectMonth > self.maxMonth - 1 ? self.maxMonth - 1 : self.selectMonth
                            }
                            self.textfieldText = "\(self.yearSorce[self.selectYear]) / \(self.monthSorce[self.selectMonth])"
                        }
                    }
                }
            }
            HStack {
                Text("\(total)")
                Text("\(amount)")
            }
        }
    }
}

//struct StatsView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatsView()
//    }
//}
