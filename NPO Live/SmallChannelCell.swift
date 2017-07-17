//
//  ChannelCell.swift
//  NPO Live
//
//  Created by Maurice van Breukelen on 21-11-15.
//  Copyright © 2015 Maurice van Breukelen. All rights reserved.
//

import Foundation
import UIKit
import NPOStream

class SmallChannelCell: UICollectionViewCell {
	
	@IBOutlet weak var logoView: UIImageView!
	
	var channel: Channel? {
		didSet {
			setupCell()
		}
	}
	
	func setupCell() {
        guard let channel = channel else { return }
        logoView.image = UIImage(named: channel.title)
	}
}
