//
//  ChannelCell.swift
//  NPO Live
//
//  Created by Bart den Hollander on 12-11-17.
//  Copyright © 2017 Bart den Hollander. All rights reserved.
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
//            addPlayer(channel?.url)
		}
	}
	
	func setupCell() {
        guard
            let channel = channel,
            let image = UIImage(named: channel.title) else { return }
        logoView.image = image
        logoView.contentMode = .scaleAspectFill
//        logoView.layer.cornerRadius = 10
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
