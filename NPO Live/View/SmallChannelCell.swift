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
import AVKit

class SmallChannelCell: UICollectionViewCell {

	@IBOutlet weak var logoView: UIImageView!

    let player = AVPlayer()
    let playerController = AVPlayerViewController()
    static let identifier: String = "SmallChannelCell"

	var channel: Channel? {
		didSet {
			setupCell()
            addPlayer(channel?.url)
		}
	}
	
	func setupCell() {
        guard
            let channel = channel,
            let image = UIImage(named: channel.title) else { return }
        logoView.image = image
        logoView.contentMode = .scaleAspectFill
        logoView.adjustsImageWhenAncestorFocused = true
        logoView.layer.cornerRadius = 10
        logoView.layer.masksToBounds = true
	}
    
    func addPlayer(_ url: URL?) {
        guard let url = url else { return }
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        player.volume = 0
        playerController.player = player
        playerController.view.frame = logoView.frame
        logoView.overlayContentView.addSubview(playerController.view)
    }
}
