//
//  SHSearchBar.swift
//  AlbumPhotoApp
//
//  Created by Marina Huber on 8/12/18.
//  Copyright © 2018 Marina Huber. All rights reserved.
//

import Foundation
import SHSearchBar

extension SearchViewController {
	
	open func imageViewWithIcon(_ icon: UIImage, rasterSize: CGFloat) -> UIImageView {
		let imgView = UIImageView(image: icon)
		imgView.frame = CGRect(x: 0, y: 0, width: icon.size.width + rasterSize * 2.0, height: icon.size.height)
		imgView.contentMode = .center
		imgView.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
		return imgView
	}
	
	
	open func defaultSearchBar(withRasterSize rasterSize: CGFloat, leftView: UIView?, rightView: UIView?, delegate: SHSearchBarDelegate, useCancelButton: Bool = true) -> SHSearchBar {
		var config = defaultSearchBarConfig(rasterSize)
		config.leftView = leftView
		config.rightView = rightView
		config.useCancelButton = useCancelButton
		
		if leftView != nil {
			config.leftViewMode = .always
		}
		
		if rightView != nil {
			config.rightViewMode = .unlessEditing
		}
		
		let bar = SHSearchBar(config: config)
		bar.delegate = delegate
		bar.placeholder = NSLocalizedString("Search Artist", comment: "")
		bar.updateBackgroundImage(withRadius: 6, corners: [.allCorners], color: UIColor.white)
		bar.layer.shadowColor = UIColor.black.cgColor
		bar.layer.shadowOffset = CGSize(width: 0, height: 3)
		bar.layer.shadowRadius = 5
		bar.layer.shadowOpacity = 0.25
		return bar
	}
	
	open func defaultSearchBarConfig(_ rasterSize: CGFloat) -> SHSearchBarConfig {
		var config: SHSearchBarConfig = SHSearchBarConfig()
		config.rasterSize = rasterSize
		//    config.cancelButtonTitle = NSLocalizedString("sbe.general.cancel", comment: "")
		config.cancelButtonTextAttributes = [.foregroundColor : UIColor.darkGray]
		config.textAttributes = [.foregroundColor : UIColor.gray]
		return config
	}
}
