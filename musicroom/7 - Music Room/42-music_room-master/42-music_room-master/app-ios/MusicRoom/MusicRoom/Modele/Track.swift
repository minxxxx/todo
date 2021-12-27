//
//  Track.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 10/26/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import Foundation


struct Track: Codable {
    var id: Int
    var _id: String?
    var readable: Bool
    var link: String?
    var album: Album?
    var status: Int?
    var artist: Artist?
    var title: String
    var duration: Int
}

struct TrackLike : Codable {
    let trackId : String
    let userCoord : Coord?
}

struct UpdateTracks : Codable {
    let roomID : String
    let tracks : [Track]
}

struct CurrentTrack: Codable {
    let eventID : String
    let trackID : String
}

struct AlbumTrack: Codable {
    var id: Int
    var readable: Bool
    var title: String
    var duration: Int
}

struct PlaylistTrackData: Codable {
    var data: [Track]
}

struct AlbumTrackData: Codable {
    var data: [AlbumTrack]
}

struct TrackData: Codable {
    var data: [Track]
}
