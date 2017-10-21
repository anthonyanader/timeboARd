//
//  MoviePoster.swift
//  BCSwiftExam
//
//  Created by Joon Jang on 9/10/17.
//  Copyright © 2017 Beasts. All rights reserved.
//

import UIKit
import BeastComponents

class MoviePoster: BCCoverContentView {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		self.titleLabel.text = nil
		self.imageView.image = nil
	}
	
	var movie: [String: Any]? {
		didSet {
			if let imageName = self.movie?["image"] as? String {
				self.imageView.image = UIImage(named: imageName)
			}

			self.titleLabel.text = self.movie?["title"] as? String
		}
	}
}
