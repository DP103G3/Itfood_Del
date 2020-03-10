//
//  Person.swift
//  itfood_del
//
//  Created by Chi Tang Sun on 2020/3/5.
//  Copyright © 2020 dp103g3. All rights reserved.
//

class Person:Codable{
    var id: Int
    var email: String
    var password: String
    var name: String
    var identityid: String
    var phone: String?
    
    public init(_ id: Int, _ email: String, _ password: String, _ name: String, _ identityid: String, _ phone: String) {
        self.id = id
        self.email = email
        self.name = name
        self.identityid = identityid
        self.phone = phone
        self.password = password
    }
}
