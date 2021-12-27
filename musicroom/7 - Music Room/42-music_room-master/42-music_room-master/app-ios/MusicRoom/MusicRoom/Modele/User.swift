//
//  User.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 11/7/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import Foundation

enum Status : String, Codable {
    case Active, Suspended, Created;
}

struct User : Codable {
    var login : String
    var email : String?
    var password : String?
    var status : Status?
    var creationDate : String?
    var id : String
    var picture : String?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case login, email, password, status, creationDate, picture
    }
}

struct DataUser : Codable {
    let token : String
    let user : User
}
