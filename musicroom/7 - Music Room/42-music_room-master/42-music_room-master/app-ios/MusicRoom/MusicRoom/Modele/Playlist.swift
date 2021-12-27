//
//  Playlist.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 11/5/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import Foundation

struct Creator: Codable {
    var id: Int?
    var name: String
}

struct Playlist: Codable {
    var `public`: Bool?
    var members: [User]?
    var creator: Creator?
    var tracks: PlaylistTrackData?
    var currentTrackId: String?
    var title: String
    var picture_medium: String?
    var _id : String?
    var id: Int?
}


struct SPlaylist : Codable {
    var id : Int?
    var title : String
    var _id : String?
}

struct SearchPlaylist : Codable{
    let data : [SPlaylist]
}

struct DataPlaylist: Codable {
    var myPlaylists: [Playlist]?
    var friendPlaylists: [Playlist]?
    var allPlaylists: [Playlist]?
}
