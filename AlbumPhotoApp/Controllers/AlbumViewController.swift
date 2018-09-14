//
//  AlbumViewController.swift
//  AlbumPhotoApp
//
//  Created by Marina Huber on 8/12/18.
//  Copyright © 2018 Marina Huber. All rights reserved.
//

import UIKit
import CoreData

//AlbumDelegate not used

class AlbumViewController: UIViewController, UITableViewDelegate, AlbumDelegate {
//TODO: show title befor with protocol, never goes here
// MARK: Album Delegate required method

	func updateTitle(_ byArtist: String?, isSearch: Bool) {
		if isSearch {
			navigationController?.navigationBar.topItem?.title = byArtist
		}
	}


	var searchVC = SearchViewController()
	@IBOutlet weak var albumTableView: UITableView!
	var nameID: String?
	private var albums: Array<AlbumName> = []
	@IBOutlet weak var albumBookmark: UIImageView!
	var savedAlbum = [CDAlbumInfo]()
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		searchVC.albumDelegate = self
		navigationController?.navigationBar.topItem?.title = ""
		showAlbums()

	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.tintColor = .black
		self.albumTableView.reloadData()
	}


	func showAlbums() {
		if let id = nameID, id.isEmpty == false {
			APIClient.getAlbumsByOneArtist(id, completionHandler: {
				albumsLoaded, error in
			guard albumsLoaded != nil else { return }
				  self.albums = albumsLoaded!
				  self.reloadAlbumsUI()

			})
		}
		
	}
	
	private func reloadAlbumsUI() {
		
		DispatchQueue.main.async(execute: { () -> Void in
			self.albumTableView.reloadData()
			let visibleInexPaths = self.albumTableView.indexPathsForVisibleRows
			
			_ = visibleInexPaths.map {
				
				$0.map {
					let cell = self.albumTableView.cellForRow(at: $0)
					cell?.animateStart(0.8, delay: Double($0.row) * 0.03, completion: {
						completed in
						
					})
					
				}
			}
			
		})
		
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "segueInfoAlbum") {
			if let indexPath = albumTableView.indexPathForSelectedRow {
				let album = albums[indexPath.row]
				let vc = segue.destination as! DetailViewController
				vc.albumID = album.albumID
			}
		}

	}
	
}



// MARK: - Table view data source and delegate
extension AlbumViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return albums.count
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let artistAlbumData = albums[indexPath.row]
		navigationController?.navigationBar.topItem?.title = artistAlbumData.artist.name
		let cell = tableView.dequeueReusableCell(withIdentifier: "cellAlbum", for: indexPath) as? AlbumCell ?? AlbumCell()

		let exists = CDAlbumInfo.isAlbumBookmarked(artistAlbumData.albumID ?? "")
		cell.bookmarkAlbums.image = UIImage(named: exists ? "bookmarked" : "un_bookmark")
		cell.textLabel?.text = artistAlbumData.name

		cell.contentView.backgroundColor = UIColor.clear
		cell.backgroundColor = UIColor.clear

		return cell
	}
}


class AlbumCell: UITableViewCell {


	@IBOutlet weak var bookmarkAlbums: UIImageView!

	override func awakeFromNib() {
		super.awakeFromNib()
		textLabel?.adjustsFontSizeToFitWidth = true
		textLabel?.sizeToFit()
		textLabel?.numberOfLines = 2
	}
	
	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		super.setHighlighted(highlighted, animated: animated)
		textLabel?.font = UIFont(name: "Helvetica-Light", size: 20)

	}

	
}



// MARK: - NSFetchedResultsControllerDelegate Example
/// Maybe arrays to accumulate large changes from our fetchedResultsController in order to process them in batches

extension AlbumViewController: NSFetchedResultsControllerDelegate {

	//	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
	//		feedView.beginUpdates()
	//	}
	//
	//	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
	//
	//	}
	//
	//	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
	//		feedView.endUpdates()
	//	}

}
