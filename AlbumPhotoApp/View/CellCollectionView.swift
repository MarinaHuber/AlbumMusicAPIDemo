//
//  CellCollectionViewCollectionViewCell.swift
//  AlbumPhotoApp
//
//  Created by Marina Huber on 8/12/18.
//  Copyright © 2018 Marina Huber. All rights reserved.
//

import UIKit

class CellCollectionView: UICollectionViewCell {
    	
	@IBOutlet weak var collectionImage: UIImageView!

	override func awakeFromNib() {
		super.awakeFromNib()
	}
	override func prepareForReuse() {
		super.prepareForReuse()
		collectionImage.image = nil
	}


}
