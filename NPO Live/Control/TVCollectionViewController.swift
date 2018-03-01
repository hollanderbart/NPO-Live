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

    let streams = ChannelProvider.streams

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
        fetchStreams(for: streams)
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
            if cell.channel.playLiveTiles {
                cell.player.play()
                cell.liveTile.alpha = 1
                cell.tinyLogoView.isHidden = false
                cell.logoView.isHidden = true
                cell.playerController.view.isHidden = false
            } else {
                cell.player.pause()
                cell.liveTile.alpha = 0
                cell.tinyLogoView.isHidden = true
                cell.logoView.isHidden = false
                cell.playerController.view.isHidden = true
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallChannelCell.identifier, for: indexPath) as? SmallChannelCell else {
                fatalError("Expected SmallChannelCell at index \(indexPath)")
            }
            cell.channel = ChannelProvider.streams[indexPath.row + 3]
            cell.channel.playLiveTiles ? cell.player.play() : cell.player.pause()
            return cell
        }
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let row: Int = collectionView == topCollectionView ? indexPath.row : indexPath.row + 3
        let channel = ChannelProvider.streams[row]
        self.performSegue(withIdentifier: "streamChannel", sender: channel)
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        switch context.nextFocusedView {
        case let cell as BigChannelCell:
            guard let indexPath = topCollectionView.indexPath(for: cell) else { return }
            let channel = ChannelProvider.streams[indexPath.row]
            channel.playLiveTiles = true
        case let cell as SmallChannelCell:
            guard let indexPath = bottomCollectionView.indexPath(for: cell) else { return }
            let channel = ChannelProvider.streams[indexPath.row + 3]
            channel.playLiveTiles = true
        default:
            break
        }

        switch context.previouslyFocusedItem {
        case let cell as BigChannelCell:
            guard let indexPath = topCollectionView.indexPath(for: cell) else { return }
            let channel = ChannelProvider.streams[indexPath.row]
            channel.playLiveTiles = false
        case let cell as SmallChannelCell:
            guard let indexPath = bottomCollectionView.indexPath(for: cell) else { return }
            let channel = ChannelProvider.streams[indexPath.row + 3]
            channel.playLiveTiles = false
        default:
            break
        }

        topCollectionView.reloadData()
        bottomCollectionView.reloadData()
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

    private func fetchStreams(for channels: [Channel]) {
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
                        } else if channel.title == "NPO Nieuws" {
                            self?.bottomCollectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
                        } else if channel.title == "NPO Politiek" {
                            self?.bottomCollectionView.reloadItems(at: [IndexPath(row: 1, section: 0)])
                        } else if channel.title == "NPO 101" {
                            self?.bottomCollectionView.reloadItems(at: [IndexPath(row: 2, section: 0)])
                        } else if channel.title == "NPO Cultura" {
                            self?.bottomCollectionView.reloadItems(at: [IndexPath(row: 3, section: 0)])
                        } else if channel.title == "NPO Zapp" {
                            self?.bottomCollectionView.reloadItems(at: [IndexPath(row: 4, section: 0)])
                        } else if channel.title == "NPO Radio 1" {
                            self?.bottomCollectionView.reloadItems(at: [IndexPath(row: 5, section: 0)])
                        } else if channel.title == "NPO Radio 2" {
                            self?.bottomCollectionView.reloadItems(at: [IndexPath(row: 6, section: 0)])
                        } else if channel.title == "NPO 3FM" {
                            self?.bottomCollectionView.reloadItems(at: [IndexPath(row: 7, section: 0)])
                        } else if channel.title == "NPO Radio 4" {
                            self?.bottomCollectionView.reloadItems(at: [IndexPath(row: 8, section: 0)])
                        } else if channel.title == "NPO FunX" {
                            self?.bottomCollectionView.reloadItems(at: [IndexPath(row: 9, section: 0)])
                        }
                    }
                }
            }
        }
    }
}
