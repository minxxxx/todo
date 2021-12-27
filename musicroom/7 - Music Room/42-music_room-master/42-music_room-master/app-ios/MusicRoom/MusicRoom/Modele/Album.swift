//
//  Album.swift
//  MusicRoom
//
//  Created by Jonathan DAVIN on 11/2/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import Foundation

struct Album : Codable {
    let id : Int
    let link : String?
    let cover : String?
    let cover_medium : String?
    let cover_big : String?
    let cover_small : String?
    let artist : Artist?
    let title : String
    var tracks : AlbumTrackData?
}

struct AlbumData: Codable {
    let data : [Album]
}
