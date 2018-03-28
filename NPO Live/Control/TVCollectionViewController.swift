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

//    let streams = ChannelProvider.streams
    let topCollectionStreams = Array(ChannelProvider.streams[0...2])
    let bottomCollectionStreams = Array(ChannelProvider.streams[3...])

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
        fetchStreams(for: topCollectionStreams)
        fetchStreams(for: bottomCollectionStreams)
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == topCollectionView ? topCollectionStreams.count : bottomCollectionStreams.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("reload 2")
        if collectionView == topCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigChannelCell.identifier, for: indexPath) as? BigChannelCell else {
                fatalError("Expected BigChannelCell at index \(indexPath)")
            }
            cell.channel = topCollectionStreams[indexPath.row]
            if cell.channel.playLiveTiles {
                cell.playLiveTileWhenReady()
            } else {
                print("reload top 2")
                cell.stopLiveTile()
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallChannelCell.identifier, for: indexPath) as? SmallChannelCell else {
                fatalError("Expected SmallChannelCell at index \(indexPath)")
            }
            cell.channel = bottomCollectionStreams[indexPath.row]
            cell.channel.playLiveTiles ? cell.player.play() : cell.player.pause()
            return cell
        }
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let channel = collectionView == topCollectionView ? indexPath.row : indexPath.row + 3
//        self.performSegue(withIdentifier: "streamChannel", sender: channel)
//
//        let row: Int =
//        let channel = streams[row]
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        var reloadTopCollectionView = false
        var reloadBottomCollectionView = false
        switch context.nextFocusedView {
        case let cell as BigChannelCell:
            guard
                let indexPath = topCollectionView.indexPath(for: cell),
                case let channel = topCollectionStreams[indexPath.row],
                !channel.playLiveTiles else { return }
            channel.playLiveTiles = true
            reloadTopCollectionView = true
            print("next bigchannel: \(indexPath.row)")
        case let cell as SmallChannelCell:
            guard
                let indexPath = bottomCollectionView.indexPath(for: cell),
                case let channel = bottomCollectionStreams[indexPath.row],
                !channel.playLiveTiles else { return }
            channel.playLiveTiles = true
            reloadBottomCollectionView = true
            print("next smallChannel: \(indexPath.row)")
        default:
            break
        }

        switch context.previouslyFocusedItem {
        case let cell as BigChannelCell:
            guard
                let indexPath = topCollectionView.indexPath(for: cell),
                case let channel = topCollectionStreams[indexPath.row],
                channel.playLiveTiles else { return }
            channel.playLiveTiles = false
            reloadTopCollectionView = true
            print("previous bigchannel: \(indexPath.row)")
        case let cell as SmallChannelCell:
            guard
                let indexPath = bottomCollectionView.indexPath(for: cell),
                case let channel = bottomCollectionStreams[indexPath.row],                channel.playLiveTiles else { return }
            channel.playLiveTiles = false
            reloadBottomCollectionView = true
            print("previous smallChannel: \(indexPath.row)")
        default:
            break
        }
        if reloadTopCollectionView {
            print("reload request top")
            topCollectionView.reloadData()
        }
        if reloadBottomCollectionView {
            print("reload request bottom")
            bottomCollectionView.reloadData()
        }
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
                    guard let strongSelf = self else { return }
                    switch result {
                    case .error(let error):
                        print(error.localizedDescription)
                    case .success(let streamUrl):
                        channel.url = streamUrl
                        if strongSelf.topCollectionStreams.contains(where: { $0.title == channel.title }) {
                            strongSelf.topCollectionView.reloadData()
                        } else if strongSelf.bottomCollectionStreams.contains(where: { $0.title == channel.title }) {
                            strongSelf.bottomCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
}
