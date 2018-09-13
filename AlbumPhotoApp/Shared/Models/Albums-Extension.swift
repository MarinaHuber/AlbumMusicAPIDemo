//
//  Albums-Extension.swift
//  AlbumPhotoApp
//
//  Created by Marina Huber on 8/15/18.
//  Copyright © 2018 Marina Huber. All rights reserved.
//

import CoreData

extension CDAlbumInfo {

// Creates a container using the model named `AlbumInfo\AlbumClass` in the main bundle Codable
	convenience init( _ album : AlbumClass ) {

		if let entity = NSEntityDescription.entity(forEntityName: "CDAlbumInfo", in: Context.managedObjectContext) {

			self.init(entity: entity, insertInto: Context.managedObjectContext)

			self.albumName = album.name
			self.imageURLString = album.image.last?.imageURL?.absoluteString
			self.mbid = album.mbid

			self.artist = CDArtist.artistWithName(album.artist)

			album.tracks.track.forEach { track in
				print("Create track", track.name)
				let _ = CDTrack(track.name, album: self)
			}

		} else {
			fatalError("Unable to find Entity Song")
		}
	}


	var imageURL : URL? {
		if let urlString = imageURLString, let url = URL(string: urlString) {
			return url
		}
		return nil
	}

	var tracksArray : [CDTrack] {
		if let tracks = tracks, let result = Array(tracks) as? [CDTrack]  {
			return result
		}
		return []
	}

	static func albumWithID ( _ id:String) -> CDAlbumInfo? {

		let request : NSFetchRequest<CDAlbumInfo> = CDAlbumInfo.fetchRequest()
		request.predicate = NSPredicate(format: "mbid = [cd] %@", id)
		do {
			if let first = try Context.managedObjectContext.fetch(request).first {
				return first
			}
		} catch {
			print(error)
		}
		return nil
	}


	static func getAllAlbums() -> [CDAlbumInfo] {
		let request : NSFetchRequest<CDAlbumInfo> = CDAlbumInfo.fetchRequest()
		do {
			return try Context.managedObjectContext.fetch(request)
		} catch {

		}
		return []
	}


	static func isAlbumBookmarked(_ id: String) -> Bool {
		let request : NSFetchRequest<CDAlbumInfo> = CDAlbumInfo.fetchRequest()
		request.predicate = NSPredicate(format: "mbid = [cd] %@", id) //mbid == %@

		do {
			return try Context.managedObjectContext.count(for: request) > 0
		} catch {
			return false
		}
	}

	

	static func printAlbums () {
		let request : NSFetchRequest<CDAlbumInfo> = CDAlbumInfo.fetchRequest()
		try? Context.managedObjectContext.fetch(request).forEach {
			print($0.albumName ?? "")
		}
	}
}


extension CDArtist {


	static func artistWithName(_ name : String ) -> CDArtist {

		let request : NSFetchRequest<CDArtist> = CDArtist.fetchRequest()
		request.predicate = NSPredicate(format: "artistName = [cd] %@", name)
		do {
			if let first = try Context.managedObjectContext.fetch(request).first {
				return first
			}
		} catch {
			print(error)
		}
		return CDArtist(name)
	}

	convenience init( _ name : String ) {
		if let entity = NSEntityDescription.entity(forEntityName: "CDArtist", in: Context.managedObjectContext) {

			self.init(entity: entity, insertInto: Context.managedObjectContext)
			self.artistName = name

		} else {
			fatalError("Unable to find Artist entity")
		}
	}
}

extension CDTrack {

	convenience init( _ name : String, album : CDAlbumInfo ) {
		if let entity = NSEntityDescription.entity(forEntityName: "CDTrack", in: Context.managedObjectContext) {

			self.init(entity: entity, insertInto: Context.managedObjectContext)
			self.trackName = name
			self.album = album

		} else {
			fatalError("Unable to find Track entity")
		}
	}


	
	static func printTracks () {
		let request : NSFetchRequest<CDTrack> = CDTrack.fetchRequest()
		try? Context.managedObjectContext.fetch(request).forEach {
			print("Track", $0.trackName ?? "")
		}
	}

}
