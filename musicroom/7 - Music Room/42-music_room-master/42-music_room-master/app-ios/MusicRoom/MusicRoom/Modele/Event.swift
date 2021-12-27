//
//  Event.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 11/19/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import Foundation

struct Address : Codable {
    let p : String
    let v : String
    let cp : String
    let r : String
    let n : String
}

struct Coord : Codable {
    let lat : Double
    let lng : Double
}

struct Location : Codable {
    let address : Address
    let coord : Coord
}

struct CreateEventRoom: Codable {
    var roomID: String
    var userID: String
}

struct LeaveEventRoom: Codable {
    var roomID: String
    var userID: String
}

struct UpdateEventTrackScore: Codable {
    var roomID: String
    var userCoord: Coord
}

struct UpdateEventTracks: Codable {
    var roomID: String
    var tracks: [Track]
}

struct UpdateEventTrack: Codable {
    var roomID: String
    var track: Track
}

struct Event : Codable {
    let _id : String?
    let creator : User?
    let title : String
    var description : String
    let location : Location
    var hasStarted: Bool
    let visibility : Int?
    var shared : Bool?
    var distance_required : Bool
    var distance_max : Int?
    let creationDate : String?
    let date : String?
    let playlist : Playlist?
    var members : [User]
    var adminMembers : [User]
    let picture : String?
    
    enum CodingKeys : String, CodingKey{
        case shared = "public"
        case creationDate = "creation_date"
        case date = "event_date"
        case hasStarted = "is_start"
        case creator, title, description, location, visibility, playlist, members, adminMembers, picture, _id, distance_required, distance_max
    }

}


struct DataEvent : Codable {
    var myEvents : [Event]
    var friendEvents : [Event]
    let allEvents : [Event]
}


enum EventType {
    case mine, friends, others
}
