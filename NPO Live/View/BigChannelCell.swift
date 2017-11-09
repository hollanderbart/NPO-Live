//
//  BigChannelCell.swift
//  Design
//
//  Created by Maurice van Breukelen on 24-11-15.
//  Copyright © 2015 Maurice van Breukelen. All rights reserved.
//

import UIKit
import NPOStream
import AVKit

class BigChannelCell: UICollectionViewCell {

	@IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var tinyLogoView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    let player = AVPlayer()
    let playerController = AVPlayerViewController()
    static let identifier: String = "BigChannelCell"

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
        tinyLogoView.adjustsImageWhenAncestorFocused = true
        logoView.contentMode = .scaleAspectFill
        logoView.adjustsImageWhenAncestorFocused = true
        logoView.layer.cornerRadius = 10
        logoView.layer.masksToBounds = true
        label.text = ""
	}

    func addPlayer(_ url: URL?) {
        guard let url = url else { return }
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        player.volume = 0
        playerController.player = player
        playerController.view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: logoView.frame.size) 
        logoView.overlayContentView.addSubview(playerController.view)
    }
}
