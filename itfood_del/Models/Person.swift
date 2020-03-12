//
//  Person.swift
//  itfood_del
//
//  Created by Chi Tang Sun on 2020/3/5.
//  Copyright © 2020 dp103g3. All rights reserved.
//

class Person: Codable{
    var del_id: Int
    var del_email: String
    var del_password: String
    var del_name: String
    var del_identityid: String
    var del_phone: String?
    var del_jointime: String!
    
    public init(_ del_id: Int, _ del_email: String, _ del_password: String, _ del_name: String, _ del_identityid: String, _ del_phone: String, _ del_jointime:String) {
        self.del_id = del_id
        self.del_email = del_email
        self.del_name = del_name
        self.del_identityid = del_identityid
        self.del_phone = del_phone
        self.del_password = del_password
        self.del_jointime = del_jointime
    }
}
