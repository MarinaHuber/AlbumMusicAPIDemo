//
//  APIRouter.swift
//  AlbumPhotoApp2
//
//  Created by Marina Huber on 8/11/18.
//  Copyright © 2018 Marina Huber. All rights reserved.
//

import Alamofire
import Foundation


// MARK: - LastFMAPI
// _LastFMAPI_ is a struct responsible for general Last FM API configurations
// API Parameter Abstraction

public enum APIRouterRequest: URLRequestConvertible {

	static let BASE_URL = "https://ws.audioscrobbler.com/2.0"
	static let APIKey = "0f1a40cf75729731a09c0125cf9710be"

	case artistByName(String, HTTPMethod)
	case albumsByArtistID(String, HTTPMethod)
	case albumInfoByID(String, HTTPMethod)


	public func asURLRequest() throws -> URLRequest {
		var request = URLRequest(url: self.url!)
		request.httpMethod = self.method.rawValue
		return request
	}
	// in case addition CRUD & Authorization a secret token
	var method: HTTPMethod {
		switch self {
		case .artistByName(_, let method): return method
		case .albumsByArtistID(_, let method): return method
		case .albumInfoByID(_, let method): return method
		}
	}

	var url: URL? {
		var parameters: [String: String] = [
			"api_key": APIRouterRequest.APIKey,
			"format": "json"
		]

		switch self {
		case .artistByName(let name, _):
			parameters["artist"] = name
			parameters["method"] = "artist.search"

		case .albumsByArtistID(let id, _):
			parameters["mbid"] = id
			parameters["method"] = "artist.gettopalbums"

		case .albumInfoByID(let id, _):
			parameters["mbid"] = id
			parameters["method"] = "album.getinfo"
		}
		//NOTE:  native way to build array for url instead of Alamofire encoding
		var components = URLComponents(string: APIRouterRequest.BASE_URL)!
		components.queryItems = Array(parameters.keys).map { URLQueryItem(name: $0, value: parameters[$0])}
		return components.url
	}


}

