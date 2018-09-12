//
//  AlbumViewController.swift
//  AlbumPhotoApp
//
//  Created by Marina Huber on 8/12/18.
//  Copyright © 2018 Marina Huber. All rights reserved.
//

import UIKit
import CoreData



class AlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	var detailVC: DetailViewController!
	@IBOutlet weak var albumTableView: UITableView!
	var nameID: String?
	private var albums: Array<AlbumName> = []
	@IBOutlet weak var albumBookmark: UIImageView!
	var savedAlbum = [CDAlbumInfo]()
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
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
	
	// MARK: - Table view data source and delegate
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return albums.count
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let artistAlbumData = albums[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "cellAlbum", for: indexPath) as? AlbumCell ?? AlbumCell()

		let exists = CDAlbumInfo.isAlbumBookmarked(artistAlbumData.albumID ?? "")
		cell.bookmarkAlbums.image = UIImage(named: exists ? "bookmarked" : "un_bookmark")
		cell.textLabel?.text = artistAlbumData.name

		cell.contentView.backgroundColor = UIColor.clear
		cell.backgroundColor = UIColor.clear
		
		return cell
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

	func album(isSaved: Bool){
		if !isSaved {
			bookmarkAlbums.image = UIImage(named: "un_bookmark")
		} else {
			bookmarkAlbums.image = UIImage(named: "un_bookmark")
		}
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
	//		switch type {
	//		case .insert:
	//			if let indexPath = newIndexPath {
	//				feedView.insertRows(at: [indexPath], with: .fade)
	//			}
	//		case .update:
	//			if let indexPath = indexPath, let cell = feedView.cellForRow(at: indexPath) as? PostTableViewCell {
	//				configureCell(cell: cell, atIndexPath: indexPath)
	//			}
	//		default: break
	//		}
	//
	//	}
	//
	//	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
	//		feedView.endUpdates()
	//	}

}
