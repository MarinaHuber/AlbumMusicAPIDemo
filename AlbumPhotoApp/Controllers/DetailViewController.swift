//
//  DetailViewController.swift
//  AlbumPhotoApp
//
//  Created by Marina Huber on 8/12/18.
//  Copyright © 2018 Marina Huber. All rights reserved.
//

import UIKit
import  AlamofireImage

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var detailTableView: UITableView!
	private var albumTracks: Array<Track> = []
	private var imagesAlbum: Array<Image> = []
	var albumID: String?

	@IBOutlet weak var image: UIImageView!
	@IBOutlet weak var artist: UILabel!
	@IBOutlet weak var album: UILabel!
	@IBOutlet weak var bookmark: UIButton!
	var selectedBookmarkBlock: (() -> ())?
	var unSelectedBookmarkBlock: (() -> ())?

	var albumInfo : AlbumClass?
	var savedAlbumInfo : CDAlbumInfo?
	var bookmarkedAll: Bool = false  {
		didSet {

			if (bookmarkedAll) {
			guard let album = albumInfo else { return }
				savedAlbumInfo = CDAlbumInfo(album)
				Context.saveContext()
				selectedBookmarkBlock?()
				//CDAlbumInfo.printAlbums()
			} else if let album = savedAlbumInfo {
				Context.managedObjectContext.delete(album)
				Context.saveContext()
				savedAlbumInfo = nil
				unSelectedBookmarkBlock?()
			}

		}
	}


	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.navigationBar.topItem?.title = ""
		if let _ = savedAlbumInfo  {
			showCDAlbum()
			bookmarkedAll = true
		} else {
			showAlbums()
		}
		self.updateBookmarkButton()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.tintColor = .white
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	if (self.isMovingFromParentViewController || self.isBeingDismissed) {
	    if let _ = savedAlbumInfo  {
	        selectedBookmarkBlock?()
	    } else {
	       unSelectedBookmarkBlock?()
	   }
	}

}

	func showCDAlbum() {
		self.artist.text = savedAlbumInfo?.artist?.artistName
		self.album.text = savedAlbumInfo?.albumName
		if let url = savedAlbumInfo?.imageURL {
			self.image.af_setImage(
				withURL: url, placeholderImage: UIImage(), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.1), runImageTransitionIfCached: false, completion: nil)
		}
	}

	func showAlbums() {
		if let id = albumID, id.isEmpty == false {
			APIClient.getAlbumInfo(id, completionHandler: {
				album, error in
				guard album != nil else { return }
				DispatchQueue.main.async(execute: { () -> Void in
					let tracks = album?.tracks.track
					self.albumInfo = album
					self.artist.text = album?.artist
					self.album.text = album?.name
					let array = album?.image
					self.imagesAlbum = array ?? []
					for image in self.imagesAlbum {
						print(image.imageURL!)
						self.image.af_setImage(
							withURL: image.imageURL!, placeholderImage: UIImage(), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.1), runImageTransitionIfCached: false, completion: nil)
					}
					self.albumTracks = tracks ?? []

					self.detailTableView.reloadData()
				})
			})
		} else {
			album.text = " No album details"
		}

	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let cdAlbum = savedAlbumInfo {
			return cdAlbum.tracks?.count ?? 0
		}
		return albumTracks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as? DetailTrackCell ?? DetailTrackCell()

		if let cdAlbum = savedAlbumInfo {
			cell.textLabel?.text = cdAlbum.tracksArray[indexPath.row].trackName

		} else {
			let tracksData = albumTracks[indexPath.row]
			cell.textLabel?.text = tracksData.name
		}

		return cell
	}
	

	@IBAction func actionBookmark(_ sender: UIButton) {
		self.bookmarkedAll = !self.bookmarkedAll
		self.updateBookmarkButton()
	}

	func updateBookmarkButton() {
		let newImage = self.bookmarkedAll ? UIImage(named: "w_bookmark") :
		UIImage(named: "w_bookmarkUn")
		bookmark.setImage(newImage, for: .normal)

	}

}



class DetailTrackCell: UITableViewCell {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		super.setHighlighted(highlighted, animated: animated)
		
	}
	
}

