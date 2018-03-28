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

    @IBOutlet weak var largeLogoView: UIImageView!
    @IBOutlet weak var smallLogoView: UIImageView!
    @IBOutlet weak var liveTile: UIImageView!
    @IBOutlet weak var label: UILabel!

    lazy var player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        player.volume = 0
        return player
    }()
    lazy var playerController: AVPlayerViewController = {
        let playerController = AVPlayerViewController()
        playerController.player = player
        return playerController
    }()

    var playbackLikelyToKeepUpKeyPathObserver: NSKeyValueObservation?
    var playbackBufferFullObserver: NSKeyValueObservation?

    static let identifier: String = "BigChannelCell"
    static let animateDuration: TimeInterval = 0.5

	var channel: Channel! {
		didSet {
            addPlayer(channel.url)
		}
	}

    override func layoutSubviews() {
        guard let image = UIImage(named: channel.title) else { return }
        largeLogoView.image = image
        smallLogoView.image = image
        label.text = ""
    }

    func addPlayer(_ url: URL?) {
        guard let url = url, channel.playLiveTiles else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        playerController.view.frame = CGRect(origin: CGPoint.zero, size: liveTile.frame.size)
    }

    func playLiveTileWhenReady() {
        guard channel.url != nil, channel.playLiveTiles else { return }
        print("play live tile \(channel.title)")
        observeBuffering()
        player.play()
    }

    func stopLiveTile() {
        print("got stop sign \(channel.title)")
        guard !smallLogoView.isHidden else { return }
        print("stop live tile \(channel.title)")
        player.pause()
        hideLiveTile()
    }

    // MARK: Private

    private func observeBuffering() {
        let playbackLikelyToKeepUpKeyPath = \AVPlayerItem.playbackLikelyToKeepUp
        playbackLikelyToKeepUpKeyPathObserver = player.currentItem?.observe(playbackLikelyToKeepUpKeyPath, options: [.new]) { [weak self] (_, _) in
            guard let strongSelf = self else { return }
            print("buffer is going to be full.")
            strongSelf.showLiveTile()
        }
    }

    private func showLiveTile() {
        guard channel.playLiveTiles else {
            stopLiveTile()
            return
        }
        print("show livetile \(channel.title)")
        liveTile.alpha = 1
        largeLogoView.isHidden = true
        liveTile.overlayContentView.addSubview(playerController.view)
        smallLogoView.isHidden = false
        playerController.view.isHidden = false
    }

    private func hideLiveTile() {
        print("hide livetile \(channel.title)")
        liveTile.alpha = 0
        largeLogoView.isHidden = false
        smallLogoView.isHidden = true
        playerController.view.isHidden = true
    }

    // MARK: Reuse

    override func prepareForReuse() {
        hideLiveTile()
        player.replaceCurrentItem(with: nil)
    }
}
