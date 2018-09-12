//
//  Albums.swift
//  AlbumPhotoApp2
//
//  Created by Marina Huber on 8/13/18.
//  Copyright © 2018 Marina Huber. All rights reserved.
//

import Foundation


struct Album: Codable {
	let topalbums: Topalbums?
}

struct Topalbums: Codable {
	let albumArray: [AlbumName]

	enum CodingKeys: String, CodingKey {
		case albumArray = "album"

	}
}

struct AlbumName: Codable {
	let name: String?
	let playcount: Int
	let albumID: String?
	let url: String
	let artist: ArtistInfo

	enum CodingKeys: String, CodingKey {
		case albumID = "mbid"
		case name, playcount, url, artist

	}
}

struct ArtistInfo: Codable {
	let name: String
	let mbid: String
	let url: URL
}
