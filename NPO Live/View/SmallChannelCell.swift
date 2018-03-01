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
    @IBOutlet weak var liveTile: UIImageView!

    let player = AVPlayer()
    let playerController = AVPlayerViewController()

    static let identifier: String = "SmallChannelCell"

	var channel: Channel! {
		didSet {
            addPlayer(channel.url)
		}
	}

    override func layoutSubviews() {
        guard let image = UIImage(named: channel.title) else { return }
        logoView.image = image
	}
    
    func addPlayer(_ url: URL?) {
        guard let url = url, channel.playLiveTiles else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.volume = 0
        playerController.player = player
        playerController.view.frame = liveTile.frame
        liveTile.alpha = 1
        liveTile.overlayContentView.addSubview(playerController.view)
        logoView.isHidden = true
    }
}
