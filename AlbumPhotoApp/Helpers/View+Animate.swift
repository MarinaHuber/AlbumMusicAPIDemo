//
//  View.swift
//  AlbumPhotoApp
//
//  Created by Marina Huber on 8/12/18.
//  Copyright © 2018 Marina Huber. All rights reserved.
//

import UIKit

extension UIView {
	
	func animateStart(_ duration: TimeInterval, delay: TimeInterval, completion: @escaping ((Bool) -> Void)) {
		
		let originalX = self.frame.origin.x
		self.frame = CGRect(x: -UIScreen.main.bounds.width, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
		self.alpha = 0.0
		
		UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
			
			self.frame = CGRect(x: originalX, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
			self.alpha = 1.0
			
		}, completion: completion)
	}
	
}
