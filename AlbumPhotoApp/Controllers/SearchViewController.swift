//
//  SearchViewController.swift
//  AlbumPhotoApp
//
//  Created by Marina Huber on 8/10/18.
//  Copyright © 2018 Marina Huber. All rights reserved.
//

import UIKit
import  SHSearchBar

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SHSearchBarDelegate {

	@IBOutlet weak var searchTableView: UITableView!
	private var artists: Array<ArtistElement> = []


	var textFieldSearch: SHSearchBar!
	var rasterSize: CGFloat = 12.0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.navigationBar.topItem?.title = ""
		createSearchBar()

	}
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}

	
	func createSearchBar() {
		navigationItem.titleView = nil
		let searchGlassIconTemplate = UIImage(named: "icons8-search")!.withRenderingMode(.alwaysTemplate)
		textFieldSearch = self.defaultSearchBar(withRasterSize: rasterSize,
												leftView: self.imageViewWithIcon(searchGlassIconTemplate, rasterSize: rasterSize),
												rightView: nil,
												delegate: self)
		
		let titleView = SearchbarTitleView(searchbar: textFieldSearch)
		navigationItem.titleView = titleView
		
		
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.tintColor = .black

	}

	func searchArtist(_ name: String?) {
			if let n = name, n.isEmpty == false {

			APIClient.getTopArtists(n, completionHandler: {
				namesLoaded, error in

				self.artists = namesLoaded
				if namesLoaded.isEmpty {
					self.alert(message: "No artist found", title: "Artist unknown")
				}
				self.reloadUI()
			})
			} else {
				self.alert(message: "No artist found", title: "Artist unknown")

		     }
	}
	func alert(message: String, title: String) {
		DispatchQueue.main.async {
			let alertController = UIAlertController(title: title, message:   message, preferredStyle: .alert)
			let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alertController.addAction(OKAction)
			self.present(alertController, animated: true)
		}

	}
	
	func reloadUI() {
		
		DispatchQueue.main.async(execute: { () -> Void in
			self.searchTableView.reloadData()
			
			let indexPathFirstVisibleRow = self.searchTableView.indexPathsForVisibleRows?.first?.row ?? 0
			let visibleInexPaths = self.searchTableView.indexPathsForVisibleRows
			
			_ = visibleInexPaths.map {
				
				$0.map {
					let cell = self.searchTableView.cellForRow(at: $0)
					cell?.animateStart(1.0, delay: Double($0.row - indexPathFirstVisibleRow) * 0.03, completion: {
						completed in
						
					})
					
				}
			}
			
		})
		
	}

	// MARK: - Table view data source and delegate
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return artists.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellData = artists[indexPath.row]

		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SearchCell ?? SearchCell()

		cell.textLabel?.text = cellData.name

		cell.contentView.backgroundColor = UIColor.clear
		cell.backgroundColor = UIColor.clear
		
		return cell
	}

	// this function is called after didSelectRowAtIndex
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "segueAlbums") {
			if let indexPath =  searchTableView.indexPathForSelectedRow {
				let artist = artists[indexPath.row]
				let vc = segue.destination as! AlbumViewController
				vc.nameID = artist.nameID
			}
		}

	}

	//MARK: - TextField delegate and listeners


	func searchBarShouldReturn(_ searchBar: SHSearchBar) -> Bool {
		textFieldSearch.resignFirstResponder()
		artists = []
		reloadUI()
		print ("text to search: \(searchBar.text ?? "error")")
		searchArtist(searchBar.text)

		return true
	}

	func searchBarShouldClear(_ searchBar: SHSearchBar) -> Bool {
		textFieldSearch.text = ""
		textFieldSearch.resignFirstResponder()
		textFieldSearch.cancelSearch()
		artists = []
		reloadUI()

		return true
	}
	
	
	
}


