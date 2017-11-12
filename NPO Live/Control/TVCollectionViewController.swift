//
//  TVCollectionViewController.swift
//  NPO Live
//
//  Created by Bart den Hollander on 12-11-17.
//  Copyright © 2017 Bart den Hollander. All rights reserved.
//

import UIKit
import AVKit
import NPOStream

final class TVCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var bottomCollectionView: UICollectionView!

    var streams = ChannelProvider.streams
    var shouldPlayLiveTiles: Bool = true

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bottomCollectionView.frame
        blurEffectView.alpha = 0.5
        view.addSubview(blurEffectView)
        view.bringSubview(toFront: bottomCollectionView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shouldPlayLiveTiles = true
        fetchStreams(streams)
        reloadAllData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        shouldPlayLiveTiles = false
        reloadAllData()
    }

    // MARK: - UICollectionViewDataSource


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollectionView {
            return 3
        } else if collectionView == bottomCollectionView {
            return ChannelProvider.streams.count - 3
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigChannelCell.identifier, for: indexPath) as? BigChannelCell else {
                fatalError("Expected BigChannelCell at index \(indexPath)")
            }
            cell.channel = ChannelProvider.streams[indexPath.row]
            shouldPlayLiveTiles ? cell.player.play() : cell.player.pause()
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallChannelCell.identifier, for: indexPath) as? SmallChannelCell else {
                fatalError("Expected SmallChannelCell at index \(indexPath)")
            }
            cell.channel = ChannelProvider.streams[indexPath.row + 3]
            shouldPlayLiveTiles ? cell.player.play() : cell.player.pause()
            return cell
        }
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let channel : Channel!
        if collectionView == topCollectionView {
            channel = ChannelProvider.streams[indexPath.row]
        } else {
            channel = ChannelProvider.streams[indexPath.row + 3]
        }

        self.performSegue(withIdentifier: "streamChannel", sender: channel)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "streamChannel",
            let destinationVC = segue.destination as? PlayerViewController,
            let channel = sender as? Channel,
            channel.url != nil else { return }
        destinationVC.channel = channel
    }

    // MARK: - Private

    private func fetchStreams(_ channels: [Channel]) {
        channels.forEach { (channel) in
            if channel.url == nil {
                NPOStream.getStream(channel.streamTitle) { [weak self] (result) in
                    switch result {
                    case .error(let error):
                        print(error.localizedDescription)
                    case .success(let streamUrl):
                        channel.url = streamUrl
                        if channel.title == "NPO 1" {
                            self?.topCollectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
                        } else if channel.title == "NPO 2" {
                            self?.topCollectionView.reloadItems(at: [IndexPath(row: 1, section: 0)])
                        } else if channel.title == "NPO 3" {
                            self?.topCollectionView.reloadItems(at: [IndexPath(row: 2, section: 0)])
                        }
                    }
                }
            }
        }
    }

    private func reloadAllData() {
        topCollectionView.reloadData()
        bottomCollectionView.reloadData()
    }
}
