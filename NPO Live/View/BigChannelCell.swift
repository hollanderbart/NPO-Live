//
//  BigChannelCell.swift
//  NPO Live
//
//  Created by Bart den Hollander on 12-11-17.
//  Copyright © 2017 Bart den Hollander. All rights reserved.
//

import UIKit
import NPOStream
import AVKit

class BigChannelCell: UICollectionViewCell {

	@IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var tinyLogoView: UIImageView!
    @IBOutlet weak var liveTile: UIImageView!
    @IBOutlet weak var label: UILabel!

    let player = AVPlayer()
    let playerController = AVPlayerViewController()
    static let identifier: String = "BigChannelCell"
    static let animateDuration: TimeInterval = 0.5

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
        tinyLogoView.image = image
        label.text = ""
	}

    func addPlayer(_ url: URL?) {
        guard let url = url else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.volume = 0
        playerController.player = player
        playerController.view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: liveTile.frame.size)
        liveTile.alpha = 1
        liveTile.overlayContentView.addSubview(playerController.view)
        tinyLogoView.isHidden = false
        logoView.isHidden = true
    }
}
