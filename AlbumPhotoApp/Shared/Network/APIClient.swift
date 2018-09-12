//
//  APIClient.swift
//  Networking
//
//  Created by Marina Huber on 2018.
//  Copyright © 2017 Marina Huber. All rights reserved.
//

import Alamofire

class APIClient {

	//  1. create basic GET request without making the object first
	//  2. getArtist,Albums and AlbumInfo is after made the object
	//  The limit of objects is 30

	public static func getTopArtists(_ artist: String,completionHandler: @escaping (_ result: Array<ArtistElement>, Error?) -> Void) {
		let request = APIRouterRequest.artistByName(artist, .get)
		Alamofire.request(request).response { (response) in
			guard let data = response.data else { return }


			do {
				let decoder = JSONDecoder()
				let artistsDecoded = try decoder.decode(Artist.self, from: data)
				let artists = artistsDecoded.results.artistmatches
				DispatchQueue.main.async() {
					for artist in artists.artist {
						print(artist.name)

						completionHandler(artists.artist, nil)


					}
				}

			} catch {
				completionHandler([], error)
				print("Error serializing json:", error)
				//Error response check
				DispatchQueue.main.async(execute: {
					if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
						//print("JSON response code:", json ?? "")
						if let code = json?["cod"] as? String {
							if code != "200" {
								if let message = json?["message"] as? String {
									print( "To the user text: ", message.localizedUppercase)

								}
								return
							}
						}
					}
				})

			}

			}.resume()


	}





	public static func getAlbumsByOneArtist(_ artistID: String, completionHandler: @escaping (_ result: Array<AlbumName>?, Error?) -> Void) {
		let request = APIRouterRequest.albumsByArtistID(artistID, .get)
		Alamofire.request(request).responseJSON { (response) in
			guard let data = response.data else { return }

			do {
				let decoder = JSONDecoder()
				let albumDecoded = try decoder.decode(Album.self, from: data)
				let albums = albumDecoded.topalbums?.albumArray
				for album in albums! {
					print(album.name ?? "")
				}
				_ = albums?.filter { album in
					return album.name != "(null)"
				}

				completionHandler(albums!, nil)

			} catch {
				completionHandler ([], error as NSError?)
			}
			}.resume()
	}

	public static func getAlbumInfo(_ albumID: String, completionHandler: @escaping (_ result: AlbumClass?, Error?) -> Void) {
        let request = APIRouterRequest.albumInfoByID(albumID, .get)
		Alamofire.request(request).response { (response) in

			guard let data = response.data else {
				return
				//TODO: Need to throw to see the missing NIL- JSON
			  //	throw JSONError.notFound("Missing JSON")
			}
			
			do {
				let decoder = JSONDecoder()
				let infoDecoded = try decoder.decode(AlbumInfo.self, from: data)
				let album = infoDecoded.album
				let images = album.tracks.track
				for track in images {
					print(track.name)
				}
				completionHandler(album, nil)
				
			} catch {
				//completionHandler("Error serializing json:", error)
				print("Error serializing json:", error)
			}
			}.resume()
	}



	
}

