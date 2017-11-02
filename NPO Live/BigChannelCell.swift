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
	@IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    
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
        tinyLogoView.image = image
        tinyLogoView.adjustsImageWhenAncestorFocused = true
        logoView.contentMode = .scaleAspectFill
        logoView.adjustsImageWhenAncestorFocused = true
        logoView.layer.cornerRadius = 10
        logoView.layer.masksToBounds = true
        
        label.text = ""

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

//    func convertImageToBW(image:UIImage) -> UIImage {
//
//        let filter = CIFilter(name: "CIPhotoEffectMono")
//
//        let ciInput = CIImage(image: image)
//        filter?.setValue(ciInput, forKey: "inputImage")
//
//        let ciOutput = filter?.outputImage
//        let ciContext = CIContext()
//        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
//
//        return UIImage(cgImage: cgImage!)
//    }

    func addPlayer(_ url: URL) {
        player = AVPlayer(url: url)
        player.volume = 0
        playerController = AVPlayerViewController()
        playerController.player = player
        playerController.view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: logoView.frame.size) 
        logoView.overlayContentView.addSubview(playerController.view)
        player.play()
    }
}
