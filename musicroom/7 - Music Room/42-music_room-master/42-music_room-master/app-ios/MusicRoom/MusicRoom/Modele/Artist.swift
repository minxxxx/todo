//
//  Artist.swift
//  MusicRoom
//
//  Created by jdavin on 11/3/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import Foundation

struct Artist : Codable {
    var id : Int?
    var picture : String?
    var picture_medium : String?
    var name : String?
    var tracklist : String?
    var nb_fan : Int?
}

struct ArtistData: Codable {
    var data : [Artist]
}
