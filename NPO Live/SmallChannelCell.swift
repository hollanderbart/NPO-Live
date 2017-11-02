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

    var player: AVPlayer!
    //    var playerLayer: AVPlayerLayer!
    var playerController: AVPlayerViewController!
    
	var channel: Channel? {
		didSet {
			setupCell()
		}
	}
	
	func setupCell() {
        guard
            let channel = channel,
            let image = UIImage(named: channel.title) else { return }
        logoView.image = image
        logoView.center = contentView.center
        logoView.adjustsImageWhenAncestorFocused = true
        logoView.layer.cornerRadius = 10
        logoView.layer.masksToBounds = true

        if channel.url == nil {
            NPOStream.getStream(channel.streamTitle) { (result) in
                switch result {
                case .error(let error):
                    print(error.localizedDescription)
                case .success(let streamUrl):
                    channel.url = streamUrl
                    self.addPlayer(streamUrl)
                }
            }
        }
	}
    
    func addPlayer(_ url: URL) {
        player = AVPlayer(url: url)
        player.volume = 0
        playerController = AVPlayerViewController()
        playerController.player = player
        
        playerController.view.frame = logoView.frame

        self.logoView.overlayContentView.addSubview(playerController.view)
        
        player.play()
    }
}

