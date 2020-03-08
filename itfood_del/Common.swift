//
//  Common.swift
//  itfood_del
//
//  Created by 莊宇軒 on 2020/3/3.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import Foundation

func executeTask(_ url_server: URL, _ requestParam: [String: Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let jsonData = try! JSONSerialization.data(withJSONObject: requestParam)
    var request = URLRequest(url: url_server)
    request.httpMethod = "POST"
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    request.httpBody = jsonData
    let sessionData = URLSession.shared
    let task = sessionData.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
}
