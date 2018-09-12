//
//  MainViewController.swift
//  AlbumPhotoApp
//
//  Created by Marina Huber on 8/10/18.
//  Copyright © 2018 Marina Huber. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
	
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var noAlbumsStoredLabel: UILabel!
	private var albumCover: Array<UIImage> = []

	private var albums = [CDAlbumInfo]()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()

	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if albums.count > 0 {
			self.navigationItem.title? = "Saved Albums"
		} else {
			self.navigationItem.title? = "No Albums"
		}
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.tintColor = .black
		albums = CDAlbumInfo.getAllAlbums()
		collectionView.reloadData()
		noAlbumsStoredLabel.isHidden = albums.count > 0
	}
	
}


//MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return albums.count
	}
	
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if indexPath.row >= albums.count {
			print(indexPath.row)
		}
		let cellData = albums[indexPath.row]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCollection", for: indexPath) as? CellCollectionView
		
			if let url = cellData.imageURL {
				cell?.collectionImage.af_setImage(
					withURL: url, placeholderImage: UIImage(), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.1), runImageTransitionIfCached: false, completion: nil)
			} else {
				cell?.collectionImage.image = nil

		}
		return cell!
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "mainCoreDataToDetail", let dest = segue.destination as? DetailViewController,
			let index = collectionView.indexPathsForSelectedItems?.first {
			dest.savedAlbumInfo = albums[index.row]
		}
	}
	
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		return CGSize(width: view.frame.width - 45, height: 120)
	}
}


