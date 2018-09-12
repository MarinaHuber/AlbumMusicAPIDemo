//
//  Image.swift
//  AlbumPhotoApp2
//
//  Created by Marina Huber on 8/14/18.
//  Copyright © 2018 Marina Huber. All rights reserved.
//

import Foundation


struct Image: Codable {
	let imageURL: URL?
	let size: String?

	private enum CodingKeys: String, CodingKey {
		case imageURL = "#text"
		case size
	}
}
