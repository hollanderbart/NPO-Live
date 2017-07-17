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
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
	var channel: Channel? {
		didSet {
			setupCell()
		}
	}
    
	func setupCell() {
		guard let channel = channel else { return }
		logoView.image = UIImage(named: channel.title)
        logoView.contentMode = .scaleAspectFill
        label.text = ""

        if channel.url == nil {
            NPOStream.getStream(channel.streamTitle) { (url, error) in
                guard let streamUrl = url else { return }
                channel.url = streamUrl
                self.addPlayer(streamUrl)
            }
        }
	}

    func addPlayer(_ url: URL) {
        player = AVPlayer(url: url)
        player.volume = 0
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.logoView.layer.bounds
        
        self.logoView.layer.addSublayer(playerLayer)
        
        player.play()
    }
    
    func focus() {
        layoutIfNeeded()
        labelBottomConstraint.constant = 20

        self.label.textColor = UIColor.white
        self.label.layer.shadowOpacity = 0.5
        self.label.layer.shadowRadius = 10.0
        self.label.layer.shadowColor = UIColor.black.cgColor
        self.label.layer.shadowOffset = CGSize(width: 0, height: 1)

        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        })
    }
	
	func unfocus() {
		layoutIfNeeded()
		labelBottomConstraint.constant = 0

		self.label.textColor = UIColor.darkGray

		UIView.animate(withDuration: 0.2, animations: {
			self.layoutIfNeeded()
			self.label.layer.shadowOpacity = 0
		}) 
	}
	
	override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if isFocused {
            focus()
        } else {
            unfocus()
        }
	}
}
