//
//  AlbumInfo.swift
//  AlbumPhotoApp2
//
//  Created by Marina Huber on 8/13/18.
//  Copyright © 2018 Marina Huber. All rights reserved.
//

import Foundation

struct AlbumInfo: Codable {
	let album: AlbumClass
}

struct AlbumClass: Codable {
	let name, artist, mbid, url: String
	let image: [Image]
	let listeners, playcount: String
	let tracks: Tracks
	let tags: Tags
	//let wiki: Wiki
}

struct Tags: Codable {
	let tag: [Tag]
}

struct Tag: Codable {
	let name, url: String
}

struct Tracks: Codable {
	let track: [Track]
}

struct Track: Codable {
	let name, url, duration: String
	let attrDetail: AttrDetail
	let streamable: Streamable
	let artistDetail: ArtistDetail

	private enum CodingKeys: String, CodingKey {
		case name, url, duration
		case attrDetail = "@attr"
		case streamable
		case artistDetail = "artist"
	}
}

struct ArtistDetail: Codable {
	let name: String
	let mbid: String
	let url: URL
}


struct AttrDetail: Codable {
	let rank: String
}

struct Streamable: Codable {
	let text, fulltrack: String

	private enum CodingKeys: String, CodingKey {
		case text = "#text"
		case fulltrack
	}
}

//struct Wiki: Codable {
//	let published, summary, content: String
//}
