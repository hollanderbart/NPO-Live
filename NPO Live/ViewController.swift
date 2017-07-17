//
//  ViewController.swift
//  NPO Live
//
//  Created by Maurice van Breukelen on 21-11-15.
//  Copyright © 2015 Maurice van Breukelen. All rights reserved.
//

import UIKit
import AVKit
import NPOStream

class ViewController: UIViewController {
	
	var getActiveShowsTimer : Timer?
	
	@IBOutlet weak var topCollectionView: UICollectionView!
	@IBOutlet weak var bottomCollectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = bottomCollectionView.frame
		blurEffectView.alpha = 0.5
		view.addSubview(blurEffectView)
		view.bringSubview(toFront: bottomCollectionView)

		getActiveShows()
        
	}

	override func viewWillAppear(_ animated: Bool) {
		getActiveShowsTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(ViewController.getActiveShows), userInfo: nil, repeats: true)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		self.getActiveShowsTimer?.invalidate()
	}
	
	func getActiveShows() {
		ChannelProviderUtil.getActiveShowNamePerChannel { (showChanged) in
            if showChanged {
                self.topCollectionView.reloadData()
            }
		}
	}
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == topCollectionView {
			return 3
		} else if collectionView == bottomCollectionView {
			return ChannelProvider.streams.count - 3
		}
		
		return 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell : UICollectionViewCell!
		if collectionView == topCollectionView {
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCell", for: indexPath) as! BigChannelCell
			(cell as! BigChannelCell).channel = ChannelProvider.streams[indexPath.row]
		} else {
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCell", for: indexPath) as! SmallChannelCell
			(cell as! SmallChannelCell).channel = ChannelProvider.streams[indexPath.row + 3]
		}
		
		return cell
	}
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let channel : Channel!
		if collectionView == topCollectionView {
			channel = ChannelProvider.streams[indexPath.row]
		} else {
			channel = ChannelProvider.streams[indexPath.row + 3]
		}
		
        NPOStream.getStream(channel.streamTitle) { (url, error) in
            guard let streamUrl = url else { return }
            channel.url = streamUrl
            self.performSegue(withIdentifier: "streamChannel", sender: channel)
        }
    }
}

// MARK: - Navigation
extension ViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "streamChannel" {
            guard
                let destinationVC = segue.destination as? PlayerViewController,
                let channel = sender as? Channel,
                channel.url != nil else { return }
                destinationVC.channel = channel
        }
    }
}
