//
//  Artists.swift
//  
//
//  Created by Marina Huber on 8/13/18.
//

import Foundation

struct Artist: Codable {
	let results: Results
}

struct Results: Codable {
	let opensearchQuery: OpensearchQuery
	let opensearchTotalResults, opensearchStartIndex, opensearchItemsPerPage: String
	let artistmatches: Artistmatches


	enum CodingKeys: String, CodingKey {
		case opensearchQuery = "opensearch:Query"
		case opensearchTotalResults = "opensearch:totalResults"
		case opensearchStartIndex = "opensearch:startIndex"
		case opensearchItemsPerPage = "opensearch:itemsPerPage"
		case artistmatches

	}
}

struct Artistmatches: Codable {
	let artist: [ArtistElement]
}

struct ArtistElement: Codable {
	let name, listeners, nameID, url: String

	enum CodingKeys: String, CodingKey {
		case nameID = "mbid"
		case name, listeners, url

	}


}

struct OpensearchQuery: Codable {
	let text, role, searchTerms, startPage: String

	enum CodingKeys: String, CodingKey {
		case text = "#text"
		case role, searchTerms, startPage
	}
}
