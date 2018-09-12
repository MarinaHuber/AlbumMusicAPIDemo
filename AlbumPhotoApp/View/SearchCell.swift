//
//  SearchCell.swift
//  AlbumPhotoApp
//
//  Created by Marina Huber on 8/12/18.
//  Copyright © 2018 Marina Huber. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {


    override func awakeFromNib() {
        super.awakeFromNib()
		textLabel?.sizeToFit()
		textLabel?.adjustsFontSizeToFitWidth = true
		textLabel?.numberOfLines = 2
    }

	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		super.setHighlighted(highlighted, animated: animated)
		textLabel?.font = UIFont(name: "Helvetica-Light", size: 20)

	}

}
